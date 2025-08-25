//
//  TabView.swift
//  Demo
//
//  Created by shinisac on 8/22/25.
//

import SwiftUI
import IsacUIComponent

struct ISTabView: View {
    var body: some View {
        IsacTabView<AnyView>(backgroundColor: .clear, tabViewItems: [
            IsacTabViewItem(title: "Home", icon: Image(systemName: "house"), content: { Text("Home View") }),
            IsacTabViewItem(title: "Settings", icon: Image(systemName: "gear"), content: { Text("Settings View") }),
            IsacTabViewItem(title: "Profile", icon: Image(systemName: "person"), content: { Text("Profile View") })
        ])
    }
}

#Preview {
    ISTabView()
}
