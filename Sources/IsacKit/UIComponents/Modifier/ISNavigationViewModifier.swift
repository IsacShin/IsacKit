//
//  ISNavigationViewModifier.swift
//  IsacKit
//
//  Created by shinisac on 8/1/25.
//

import SwiftUI

@available(iOS 13.0, *)
public struct ISNavigationViewModifier: ViewModifier {
    init(navigationBackgroundColor: UIColor = .clear,
         navigationTitleColor: UIColor = .black) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = navigationBackgroundColor  // 원하는 색상으로 변경
        appearance.shadowColor = .clear
        // Large Navigation Title
        appearance.largeTitleTextAttributes = [.foregroundColor: navigationTitleColor] // Large title 색상
        appearance.titleTextAttributes = [.foregroundColor: navigationTitleColor] // 일반 제목 색상
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    public func body(content: Content) -> some View {
        content
    }
}
