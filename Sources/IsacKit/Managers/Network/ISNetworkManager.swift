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

    // MARK: - GET
    public func get<T: Decodable>(
        from url: URL,
        parameters: [String: String]? = nil,
        headers: [String: String] = [:],
        responseType: T.Type
    ) async throws -> T {
        var finalURL = url
        if let queryParameters = parameters {
            finalURL = url.appendingQueryParameters(queryParameters)
        }

        return try await request(
            url: finalURL,
            method: "GET",
            headers: headers,
            responseType: responseType
        )
    }

    // MARK: - POST
    public func post<T: Decodable, U: Encodable>(
        to url: URL,
        parameters: U,
        headers: [String: String] = [:],
        responseType: T.Type
    ) async throws -> T {
        let bodyData = try JSONEncoder().encode(parameters)
        return try await request(
            url: url,
            method: "POST",
            body: bodyData,
            headers: headers,
            responseType: responseType
        )
    }

    // MARK: - Internal Request Handler
    private func request<T: Decodable>(
        url: URL,
        method: String,
        body: Data? = nil,
        headers: [String: String] = [:],
        responseType: T.Type
    ) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        request.allHTTPHeaderFields = headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // 🔍 Logging Request
        print("[\(method)] \(url.absoluteString)")
        if let body = body {
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
}
