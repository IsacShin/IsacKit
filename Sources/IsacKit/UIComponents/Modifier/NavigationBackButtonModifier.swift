//
//  File.swift
//  IsacKit
//
//  Created by shinisac on 7/8/25.
//

import SwiftUI

@available(iOS 15.0, *)
public struct NavigationBackButtonModifier: ViewModifier {
    let color: Color
    let action: () -> Void
    
    public init(color: Color = .white, action: @escaping () -> Void) {
        self.color = color
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        action()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(color)
                    }
                }
            }
    }
}
