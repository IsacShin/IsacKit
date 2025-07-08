//
//  File.swift
//  IsacKit
//
//  Created by shinisac on 7/8/25.
//

import SwiftUI

@available(iOS 15.0, *)
extension View {
    public func customBackButton(buttonColor: Color = .white,
                                 action: @escaping () -> Void) -> some View {
        self.modifier(NavigationBackButtonModifier(color: buttonColor,
                                                   action: action))
    }
}
