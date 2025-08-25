//
//  ISWebView.swift
//  Demo
//
//  Created by shinisac on 8/22/25.
//

import SwiftUI
import IsacUIComponent

struct ISWebView: View {
    var body: some View {
        IsacWebView(url: URL(string: "https://www.apple.com")!,
                  isLoading: .constant(false),
                  canGoBack: .constant(false),
                  canGoForward: .constant(false),
                  webTitle: .constant(nil),
                  messageHandlerName: "exampleHandler",
                  onReceiveMessage: { message in
                      print("Received message: \(message.body)")
                  })
    }
}

#Preview {
    ISWebView()
}
