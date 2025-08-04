//
//  SwiftUIView.swift
//  IsacKit
//
//  Created by shinisac on 8/1/25.
//

import SwiftUI

@available(iOS 14.0, *)
struct ISNavigationView<Content: View>: View {
    @ObservedObject private var manager = ISNavigationManager.shared
    private let content: Content
    private let navigationTitle: String?
    init(navigationTitle: String? = nil,
         @ViewBuilder content: () -> Content) {
        self.navigationTitle = navigationTitle
        self.content = content()
    }

    var body: some View {
        NavigationView {
            ZStack {
                content
                
                // NavigationLink 전환
                NavigationLink(
                    destination: manager.activeView?.presentationStyle == .navigationLink
                        ? manager.activeView?.view
                        : nil,
                    isActive: Binding(
                        get: { manager.activeView?.presentationStyle == .navigationLink },
                        set: { if !$0 { manager.pop() } }
                    )
                ) {
                    EmptyView()
                }
                .hidden()
            }
            .sheet(item: Binding(
                get: { manager.viewStack.last(where: { $0.presentationStyle == .sheet }) },
                set: { if $0 == nil { manager.pop() } }
            )) { item in
                item.view
            }
            .fullScreenCover(item: Binding(
                get: { manager.viewStack.last(where: { $0.presentationStyle == .fullScreenCover }) },
                set: { if $0 == nil { manager.pop() } }
            )) { item in
                item.view
            }
            
            .navigationTitle(navigationTitle ?? "")
        }
        .modifier(ISNavigationViewModifier(navigationBackgroundColor: .clear,
                                           navigationTitleColor: .black))
    }
}

@available(iOS 14.0, *)
#Preview {
    ISNavigationView(navigationTitle: "Navigation View") {
        Button {
            ISNavigationManager.shared.push(
                Text("Push New View")
                    .navigationBarBackButtonHidden()
                    .customBackButton(buttonColor: .black,
                                      action: {
                                          ISNavigationManager.shared.pop()
                                      }),
                id: "newView",
                style: .navigationLink
            )
        } label: {
            Text("Push New View")
        }

    }
}
