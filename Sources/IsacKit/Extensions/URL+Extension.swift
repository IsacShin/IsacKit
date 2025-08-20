//
//  File.swift
//  IsacKit
//
//  Created by shinisac on 7/8/25.
//

import Foundation

public extension URL {
    func appendingQueryParameters(_ parameters: [String: String]) -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return self
        }
        components.queryItems = (components.queryItems ?? []) + parameters.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        return components.url ?? self
    }
}
