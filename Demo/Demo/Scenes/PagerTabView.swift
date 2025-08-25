//
//  PagerTabView.swift
//  Demo
//
//  Created by shinisac on 8/22/25.
//

import SwiftUI
import IsacUIComponent

struct PagerTabView: View {
    var body: some View {
        IsacPagerTabView<AnyView>(tabs: [
            IsacTabItem(title: "Tab 1") {
                Text("Content for Tab 1")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.red.opacity(0.3))
            },
            IsacTabItem(title: "Tab 2") {
                Text("Content for Tab 2")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.green.opacity(0.3))
            },
            IsacTabItem(title: "Tab 3") {
                Text("Content for Tab 3")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.blue.opacity(0.3))
            }
        ])
    }
}

#Preview {
    PagerTabView()
}
