//
//  File.swift
//  IsacKit
//
//  Created by shinisac on 7/8/25.
//

import SwiftUI

@available(iOS 14.0, *)
extension View {
    public func customBackButton(buttonColor: Color = .white,
                                 action: @escaping () -> Void) -> some View {
        self.modifier(ISNavigationBackButtonModifier(color: buttonColor,
                                                   action: action))
    }
}


@available(iOS 13.0, *)
extension View {
    public func isNavigationViewModifier() -> some View {
        self.modifier(ISNavigationViewModifier())
    }
}
@available(iOS 13.0, *)
public struct SizePreferenceKey: @preconcurrency PreferenceKey {
    @MainActor public static var defaultValue: CGSize = .zero

    public static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        let next = nextValue()
        value = CGSize(
            width: max(value.width, next.width),
            height: max(value.height, next.height)
        )
    }
}
@available(iOS 13.0, *)
extension View {
    func measureSize(using key: SizePreferenceKey.Type = SizePreferenceKey.self) -> some View {
        background(
            GeometryReader { geo in
                Color.clear
                    .preference(key: key, value: geo.size)
            }
        )
    }
}
