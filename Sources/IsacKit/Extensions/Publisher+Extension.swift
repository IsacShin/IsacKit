//
//  File.swift
//  IsacKit
//
//  Created by shinisac on 8/20/25.
//

import Foundation
import Combine

@available(iOS 13.0, *)
public extension Publisher {
    @discardableResult
    func sinkPrint(_ prefix: String = "") -> AnyCancellable {
        sink(
            receiveCompletion: { _ = print("\(prefix) completion: \($0)") },
            receiveValue: { _ = print("\(prefix) value: \($0)") }
        )
    }
}
