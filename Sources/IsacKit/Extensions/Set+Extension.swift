//
//  File.swift
//  IsacKit
//
//  Created by shinisac on 8/20/25.
//

import Foundation

public extension Set {
    mutating func toggle(_ element: Element) {
        if contains(element) {
            remove(element)
        } else {
            insert(element)
        }
    }
}
