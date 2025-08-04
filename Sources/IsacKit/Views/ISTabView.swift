//
//  SwiftUIView.swift
//  IsacKit
//
//  Created by shinisac on 7/31/25.
//

import SwiftUI

@available(iOS 14.0, *)
public struct ISTabViewItem<Content: View>: Identifiable {
    public let id = UUID()
    public let title: String
    public let iconImage: Image
    public let content: AnyView

    public init<V: View>(title: String, icon: Image, @ViewBuilder content: () -> V) {
        self.title = title
        self.iconImage = icon
        self.content = AnyView(content())
    }
}

@available(iOS 14.0, *)
public struct ISTabView<Content: View>: View {
    @State private(set) var currentIndex = 0
    public let tabViewItems: [ISTabViewItem<Content>] // 탭 아이템 배열
    public let selectTintColor: Color // 탭 아이템 색상

    init(backgroundColor: UIColor = .white,
         tabViewLineHidden: Bool = true,
         selectTintColor: Color = .black,
         deSelectTintColor: UIColor = .systemGray,
         tabViewItems: [ISTabViewItem<Content>]) {
        self.tabViewItems = tabViewItems
        self.selectTintColor = selectTintColor
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = backgroundColor // 원하는 배경색으로 변경
        tabBarAppearance.shadowColor = tabViewLineHidden ? .clear : backgroundColor
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = deSelectTintColor
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: deSelectTintColor]
         
        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
    
    public var body: some View {
        TabView {
            ForEach(tabViewItems.indices, id: \.self) { index in
                tabViewItems[index].content
                    .tabItem {
                        tabViewItems[index].iconImage
                        Text(tabViewItems[index].title)
                    }
                    .tag(index)
            }
        }
        .accentColor(selectTintColor)
    }
}

@available(iOS 14.0, *)
#Preview {
    ISTabView<AnyView>(backgroundColor: .clear, tabViewItems: [
        ISTabViewItem(title: "Home", icon: Image(systemName: "house"), content: { Text("Home View") }),
        ISTabViewItem(title: "Settings", icon: Image(systemName: "gear"), content: { Text("Settings View") }),
        ISTabViewItem(title: "Profile", icon: Image(systemName: "person"), content: { Text("Profile View") })
    ])
}
