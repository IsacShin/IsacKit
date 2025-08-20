//
//  File.swift
//  IsacKit
//
//  Created by shinisac on 8/20/25.
//

import Foundation

public extension Array {
    subscript (safe index: Int) -> Element? {
        guard index > -1 else {
            return nil
        }
        return index < count ? self[index] : nil
    }
}
