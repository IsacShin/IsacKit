//
//  File.swift
//  IsacKit
//
//  Created by shinisac on 8/5/25.
//

import SwiftUI
import WebKit

// 웹뷰 저장소
final class WebViewStore {
    var webView: WKWebView?
}

@available(iOS 13.0, *)
/// ISWKWebView는 SwiftUI에서 WKWebView를 사용할 수 있게 해주는 UIViewRepresentable 래퍼입니다.
///
/// - Parameters:
///   - url: 로드할 웹 페이지의 URL을 바인딩으로 전달합니다.
///   - isLoading: 로딩 상태를 바인딩으로 전달합니다. 웹 페이지가 로드되는 중이면 true입니다.
///   - webViewStore: 외부에서 WKWebView 인스턴스를 접근하거나 재사용하기 위해 전달합니다.
///   - messageHandlerName: JavaScript에서 메시지를 전달할 때 사용할 핸들러 이름입니다 (옵션).
///   - onReceiveMessage: JavaScript에서 메시지를 수신했을 때 호출되는 클로저입니다 (옵션).
///
/// 사용 예시:
/// ```swift
/// struct ContentView: View {
///     @State private var url = URL(string: "https://example.com")!
///     @State private var isLoading = false
///     let webViewStore = WebViewStore()
///
///     var body: some View {
///         ISWKWebView(
///             url: $url,
///             isLoading: $isLoading,
///             webViewStore: webViewStore,
///             messageHandlerName: "iosHandler",
///             onReceiveMessage: { message in
///                 print("Received message from JS: \(message.body)")
///             }
///         )
///     }
/// }
/// ```
///
/// JavaScript 측 예시 (웹 페이지 내에서 실행):
/// ```javascript
/// if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.iosHandler) {
///     window.webkit.messageHandlers.iosHandler.postMessage({
///         type: "greeting",
///         value: "Hello from JavaScript"
///     });
/// }
/// ```
///
/// Swift에서 message.body를 처리하는 방법 예시:
/// ```swift
/// onReceiveMessage: { message in
///     if let body = message.body as? [String: Any],
///        let type = body["type"] as? String,
///        let value = body["value"] {
///         print("Received JS Message of type: \(type), value: \(value)")
///     }
/// }
/// ```
internal struct ISWKWebView: UIViewRepresentable {
    @Binding var url: URL
    @Binding var isLoading: Bool
    var webViewStore: WebViewStore
    var messageHandlerName: String? = nil
    var onReceiveMessage: ((WKScriptMessage) -> Void)? = nil
    
    // 마지막으로 로드한 URL을 추적하기 위한 변수
    @State private var lastLoadedURL: URL?
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webViewStore.webView = webView
        
        // 초기 로드
        let request = URLRequest(url: url)
        webView.load(request)
        lastLoadedURL = url
        
        if let messageHandlerName = messageHandlerName, let onReceiveMessage = onReceiveMessage {
            webView.configuration.userContentController.add(context.coordinator, name: messageHandlerName)
            context.coordinator.onReceiveMessage = onReceiveMessage
        }
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        // 현재 URL이 마지막으로 로드한 URL과 다를 때만 새로 로드
        if url != lastLoadedURL {
            let request = URLRequest(url: url)
            webView.load(request)
            lastLoadedURL = url
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var parent: ISWKWebView
        var onReceiveMessage: ((WKScriptMessage) -> Void)?
        
        init(_ parent: ISWKWebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
            
            if let url = webView.url {
                // URL 변경 시 바인딩 업데이트 (페이지 내 이동 시)
                if parent.url != url {
                    parent.url = url
                    parent.lastLoadedURL = url  // 마지막 로드 URL 업데이트
                }
            }
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
            print("웹페이지 로딩 실패: \(error.localizedDescription)")
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url {
                let urlString = url.absoluteString
                
                // 외부 앱으로 연결되는 스킴 처리 (tel:, mailto: 등)
                if !urlString.hasPrefix("http://") && !urlString.hasPrefix("https://") &&
                    UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                    decisionHandler(.cancel)  // 웹뷰에서는 처리하지 않음
                    return
                }
            }
            
            // 기본적으로 웹뷰에서 계속 처리
            decisionHandler(.allow)
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            onReceiveMessage?(message)
        }
    }
}
