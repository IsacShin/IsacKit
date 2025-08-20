//
//  File.swift
//  IsacKit
//
//  Created by shinisac on 8/20/25.
//

import Foundation

public extension Optional {
    var isNil: Bool {
        self == nil
    }
    
    var isNotNil: Bool {
        self != nil
    }
    
    func or(_ defaultValue: Wrapped) -> Wrapped {
        self ?? defaultValue
    }
    
    func unwrap(orThrow error: @autoclosure () -> Error) throws -> Wrapped {
        guard let self = self else { throw error() }
        return self
    }
}
