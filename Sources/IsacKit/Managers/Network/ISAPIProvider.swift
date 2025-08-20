//
//  File.swift
//  IsacKit
//
//  Created by shinisac on 7/9/25.
//

import Foundation
import Combine

@available(iOS 13.0, *)
final public class ISAPIProvider {
    @MainActor public static let shared = ISAPIProvider()
    private let session: URLSession

    init() {
        let config = URLSessionConfiguration.default
        config.protocolClasses = [ISAPILoggingURLProtocol.self] + (config.protocolClasses ?? [])
        self.session = URLSession(configuration: config)
    }
    
    /// Combine Request 함수
    func request<T: Decodable>(_ router: ISAPIRouter) -> AnyPublisher<T, ISAPIError> {
        let request: URLRequest
        do {
            request = try makeURLRequest(from: router)
            
        } catch {
            return Fail(error: error as? ISAPIError ?? ISAPIError.custom(message: error.localizedDescription)).eraseToAnyPublisher()
        }
        
        // 이제 session을 통해 API 호출하면 로깅됨
        // URLSession dataTaskPublisher 사용
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw ISAPIError.invalidResponse
                }
                guard (200..<300).contains(httpResponse.statusCode) else {
                    throw ISAPIError.serverError(statusCode: httpResponse.statusCode)
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> ISAPIError in
                // 에러를 APIError로 변환
                if let apiError = error as? ISAPIError {
                    return apiError
                } else if error is DecodingError {
                    return ISAPIError.decodingFailed
                } else {
                    return ISAPIError.custom(message: error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
    }
    
    /// Async Request 함수
    func request<T: Decodable>(_ router: ISAPIRouter) async throws -> T {
        let request = try makeURLRequest(from: router)

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ISAPIError.invalidResponse
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw ISAPIError.serverError(statusCode: httpResponse.statusCode)
        }
        
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            throw ISAPIError.decodingFailed
        }
    }
    
    /// Common URLRequest 생성 함수
    private func makeURLRequest(from router: ISAPIRouter) throws -> URLRequest {
        guard var components = URLComponents(url: URL(string: router.baseURL)!.appendingPathComponent(router.path),
                                             resolvingAgainstBaseURL: false) else {
            throw ISAPIError.invalidURL
        }
        
        components.queryItems = router.queryParameters
        
        guard let url = components.url else {
            throw ISAPIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = router.method.rawValue
        
        router.headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        request.httpBody = router.body
        
        return request
    }
}
