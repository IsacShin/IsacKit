//
//  File.swift
//  IsacKit
//
//  Created by shinisac on 7/9/25.
//

import Foundation

@available(iOS 13.0, *)
final public class ISNetworkManager {
    @MainActor public static let shared = ISNetworkManager()
    private init() {}

    public func request<T: Decodable>(
        with router: ISNetworkRouter,
        responseType: T.Type
    ) async throws -> T {
        let request = router.urlRequest
        return try await perform(request: request, responseType: responseType)
    }

    // MARK: - Internal Request Handler
    private func perform<T: Decodable>(
        request: URLRequest,
        responseType: T.Type
    ) async throws -> T {
        // 🔍 Logging Request
        print("[\(request.httpMethod ?? "UNKNOWN")] \(request.url?.absoluteString ?? "-")")
        if let body = request.httpBody {
            print("Request Body: \(String(data: body, encoding: .utf8) ?? "-")")
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw ISAPIError.invalidResponse
            }

            // 🔍 Logging Response
            print("Status Code: \(httpResponse.statusCode)")
            print("Response Body: \(String(data: data, encoding: .utf8) ?? "-")")

            guard 200..<300 ~= httpResponse.statusCode else {
                throw ISAPIError.serverError(statusCode: httpResponse.statusCode)
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                return decoded
            } catch {
                throw ISAPIError.decodingFailed
            }

        } catch {
            // 🔍 Logging Error
            print("Network Error: \(error.localizedDescription)")
            throw error as? ISAPIError ?? ISAPIError.custom(message: error.localizedDescription)
        }
    }
    
    
    //    // MARK: - GET
    //    public func get<T: Decodable>(
    //        from url: URL,
    //        parameters: [String: String]? = nil,
    //        headers: [String: String] = [:],
    //        responseType: T.Type
    //    ) async throws -> T {
    //        var finalURL = url
    //        if let queryParameters = parameters {
    //            finalURL = url.appendingQueryParameters(queryParameters)
    //        }
    //
    //        var request = URLRequest(url: finalURL)
    //        request.httpMethod = "GET"
    //        request.allHTTPHeaderFields = headers
    //        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //        return try await perform(request: request, responseType: responseType)
    //    }
    //
    //    // MARK: - POST
    //    public func post<T: Decodable, U: Encodable>(
    //        to url: URL,
    //        parameters: U,
    //        headers: [String: String] = [:],
    //        responseType: T.Type
    //    ) async throws -> T {
    //        let bodyData = try JSONEncoder().encode(parameters)
    //        var request = URLRequest(url: url)
    //        request.httpMethod = "POST"
    //        request.httpBody = bodyData
    //        request.allHTTPHeaderFields = headers
    //        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //        return try await perform(request: request, responseType: responseType)
    //    }

}
