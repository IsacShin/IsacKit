//
//  File.swift
//  IsacKit
//
//  Created by shinisac on 7/8/25.
//

import SwiftUI

@available(iOS 14.0, *)
public struct ISTextModifier: ViewModifier {
    let font: Font
    let foregroundColor: Color
    let backgroundColor: Color?
    
    public init(font: Font = .system(size: 18), foregroundColor: Color = .black, backgroundColor: Color? = nil) {
        self.font = font
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
    }
    
    public func body(content: Content) -> some View {
        content
            .font(font)
            .accentColor(foregroundColor)
            .background(backgroundColor)
    }
}
