//
//  File.swift
//  IsacKit
//
//  Created by shinisac on 8/20/25.
//

import Foundation

public extension Dictionary {
    mutating func merge(_ dict: [Key: Value]) {
        dict.forEach { self[$0] = $1 }
    }
    
    func jsonString(prettyPrinted: Bool = false) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: prettyPrinted ? .prettyPrinted : []) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
