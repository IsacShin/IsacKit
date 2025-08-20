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
internal protocol ISAPILoggerProtocol {
    func logRequest(_ request: URLRequest)
    func logResponse(data: Data, response: URLResponse)
    func logError(_ error: Error)
}

@available(iOS 14.0, *)
internal final class ISAPILogger: ISAPILoggerProtocol {
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

@available(iOS 13.0, *)
internal final class ISAPILoggingURLProtocol: URLProtocol, @unchecked Sendable {
    private var dataTask: URLSessionDataTask?
    
    override class func canInit(with request: URLRequest) -> Bool {
        // http, https만 로깅
        return request.url?.scheme == "http" || request.url?.scheme == "https"
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        // Request 로깅
        if let url = request.url {
            print("➡️ Request: \(url.absoluteString)")
        }
        if let headers = request.allHTTPHeaderFields {
            print("📑 Headers: \(headers)")
        }
        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            print("📦 Request Body: \(bodyString)")
        }
        
        // 실제 요청 실행
        let session = URLSession(configuration: .default)
        dataTask = session.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                print("⬅️ Response: \(httpResponse.statusCode) for \(httpResponse.url?.absoluteString ?? "")")
                print("📑 Headers: \(httpResponse.allHeaderFields)")
            }
            
            if let data = data,
               let bodyString = String(data: data, encoding: .utf8) {
                print("📦 Response Body: \(bodyString)")
            }
            
            if let error = error {
                print("❌ Error: \(error)")
            }
            
            // 클라이언트에 전달
            
            if let response = response {
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            if let data = data {
                self.client?.urlProtocol(self, didLoad: data)
            }
            self.client?.urlProtocolDidFinishLoading(self)
        }
        dataTask?.resume()
    }
    
    override func stopLoading() {
        dataTask?.cancel()
    }
}
