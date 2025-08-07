//
//  File.swift
//  IsacKit
//
//  Created by shinisac on 8/7/25.
//

// ISDefaultNetworkLogger.swift
import Foundation
import OSLog

@available(iOS 14.0, *)
internal protocol ISNetworkLoggerProtocol {
    func logRequest(_ request: URLRequest)
    func logResponse(data: Data, response: URLResponse)
    func logError(_ error: Error)
}

@available(iOS 14.0, *)
internal final class ISNetworkLogger: ISNetworkLoggerProtocol {
    private let logger = Logger(subsystem: "com.isac.network", category: "network")

    public init() {}

    public func logRequest(_ request: URLRequest) {
        logger.debug("[\(request.httpMethod ?? "UNKNOWN")] \(request.url?.absoluteString ?? "-")")
        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            logger.debug("Request Body: \(bodyString)")
        }
    }

    public func logResponse(data: Data, response: URLResponse) {
        if let httpResponse = response as? HTTPURLResponse {
            logger.debug("Status Code: \(httpResponse.statusCode)")
        }
        if let body = String(data: data, encoding: .utf8) {
            logger.debug("Response Body: \(body)")
        }
    }

    public func logError(_ error: Error) {
        logger.error("Network Error: \(error.localizedDescription)")
    }
}
