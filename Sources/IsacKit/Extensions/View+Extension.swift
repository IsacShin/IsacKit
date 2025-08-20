//
//  File.swift
//  IsacKit
//
//  Created by shinisac on 7/8/25.
//

import SwiftUI

@available(iOS 14.0, *)
public extension View {
    func customBackButton(buttonColor: Color = .white,
                                 action: @escaping () -> Void) -> some View {
        self.modifier(ISNavigationBackButtonModifier(color: buttonColor,
                                                   action: action))
    }
}

@available(iOS 13.0, *)
public extension View {
    func isNavigationViewModifier() -> some View {
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
public extension View {
    func measureSize(using key: SizePreferenceKey.Type = SizePreferenceKey.self) -> some View {
        background(
            GeometryReader { geo in
                Color.clear
                    .preference(key: key, value: geo.size)
            }
        )
    }
}

@available(iOS 13.0, *)
public extension View {
    @ViewBuilder
    func conditionalModifier<T: View>(_ condition: Bool, _ modifier: (Self) -> T) -> some View {
        if condition {
            modifier(self)
        } else {
            self
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

@available(iOS 13.0, *)
struct RoundedCorner: Shape {
    var radius: CGFloat = .zero
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
