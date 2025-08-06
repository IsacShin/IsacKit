//
//  SwiftUIView.swift
//  IsacKit
//
//  Created by shinisac on 8/5/25.
//

import SwiftUI
import WebKit

@available(iOS 14.0, *)
public struct ISWebView: View {
    @Binding private var url: URL
    @Binding private var isLoading: Bool
    @Binding private var canGoBack: Bool
    @Binding private var canGoForward: Bool
    @Binding private var webTitle: Text?
    
    // 웹뷰에 접근하기 위한 참조
    @State private var webViewStore = WebViewStore()
    
    public var messageHandlerName: String? = nil
    public var onReceiveMessage: ((WKScriptMessage) -> Void)? = nil
    
    init(url: Binding<URL> = .constant(URL(string: "https://www.example.com")!),
        isLoading: Binding<Bool> = .constant(false),
        canGoBack: Binding<Bool> = .constant(false),
        canGoForward: Binding<Bool> = .constant(false),
        webTitle: Binding<Text?> = .constant(nil),
        messageHandlerName: String? = nil,
        onReceiveMessage: ((WKScriptMessage) -> Void)? = nil) {
        self._url = url
        self._isLoading = isLoading
        self._canGoBack = canGoBack
        self._canGoForward = canGoForward
        self._webTitle = webTitle
        self.messageHandlerName = messageHandlerName
        self.onReceiveMessage = onReceiveMessage
    }
    
    public var body: some View {
        ZStack {
            VStack {
                if let webTitle = webTitle {
                    webTitle
                }
                
                ISWKWebView(
                    url: $url,
                    isLoading: $isLoading,
                    webViewStore: webViewStore,
                    messageHandlerName: messageHandlerName,
                    onReceiveMessage: onReceiveMessage
                )
            }
            
            // 로딩 인디케이터
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .onDisappear {
            if let messageHandlerName = messageHandlerName {
                webViewStore.webView?.configuration.userContentController.removeScriptMessageHandler(forName: messageHandlerName)
            }
        }
    }
}

@available(iOS 14.0, *)
#Preview {
    ISWebView(url: .constant(URL(string: "https://www.example.com")!),
              isLoading: .constant(false),
              canGoBack: .constant(false),
              canGoForward: .constant(false),
              webTitle: .constant(nil),
              messageHandlerName: "exampleHandler",
              onReceiveMessage: { message in
                  print("Received message: \(message.body)")
              })
}
