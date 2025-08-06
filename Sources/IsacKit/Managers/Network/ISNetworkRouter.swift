//
//  File.swift
//  IsacKit
//
//  Created by shinisac on 8/4/25.
//

import Foundation

/**
 Example Usage:
 - Router
 enum UserRouter: NetworkRouter {
     case createUser(name: String, email: String)

     var baseURL: URL { URL(string: "https://jsonplaceholder.typicode.com")! }

     var path: String {
         switch self {
         case .createUser: return "/users"
         }
     }

     var method: String {
         "POST"
     }

     var headers: [String : String] {
         ["Content-Type": "application/json"]
     }

     var queryParameters: [String : String]? { nil }

     var body: Data? {
         switch self {
         case .createUser(let name, let email):
             let payload = ["name": name, "email": email]
             return try? JSONSerialization.data(withJSONObject: payload)
         }
     }
 }
 - Model
 struct User: Decodable {
     let id: Int
     let name: String
     let email: String
 }
 
 - Repository
 final class UserRepository {
     func createUser(name: String, email: String) async throws -> User {
         return try await ISNetworkManager.shared.request(
             with: UserRouter.createUser(name: name, email: email),
             responseType: User.self
         )
     }
 }
 
 - ViewModel
 func createUser(name: String, email: String) async {
         do {
             let createdUser = try await repository.createUser(name: name, email: email)
             self.user = createdUser
         } catch {
             self.errorMessage = error.localizedDescription
         }
     }
 }
 */

public protocol ISNetworkRouter {
    var baseURL: URL { get }
    var path: String { get }
    var method: String { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String]? { get }
    var body: Data? { get }
}

extension ISNetworkRouter {
    var urlRequest: URLRequest {
        var url = baseURL.appendingPathComponent(path)
        if let queryParameters = queryParameters {
            url = url.appendingQueryParameters(queryParameters)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        request.allHTTPHeaderFields = headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}
