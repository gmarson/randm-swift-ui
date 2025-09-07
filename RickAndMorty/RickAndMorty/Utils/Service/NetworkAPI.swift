//
//  NetworkError.swift
//  RickAndMorty
//
//  Created by Gabriel Marson on 06/09/25.
//

import Foundation

// MARK: - Network Error Types
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case httpError(Int, String?)
    case networkError(Error)
    case invalidResponse
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .httpError(let code, let message):
            return "HTTP error \(code): \(message ?? "Unknown error")"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response"
        }
    }
}

// MARK: - HTTP Method
enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}

// MARK: - Request Protocol
protocol NetworkRequest {
    associatedtype ResponseType: Codable
    
    var url: URL { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
    
}

// MARK: - Default Implementation
extension NetworkRequest {
    var method: HTTPMethod { .GET }
    var headers: [String: String]? { nil }
    var body: Data? { nil }
}

// MARK: - URLSession Protocol for Testing
protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

// MARK: - Generic Network Service
class NetworkService {
    
    private let session: URLSessionProtocol
    private let decoder: JSONDecoder = JSONDecoder()
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    // MARK: - Generic Request Method
    func execute<T: NetworkRequest>(_ request: T) async throws -> T.ResponseType {
        let urlRequest = try buildURLRequest(from: request)
        
        do {
            let (data, response) = try await session.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            try validateHTTPResponse(httpResponse, data: data)
            
            do {
                let decodedResponse = try decoder.decode(T.ResponseType.self, from: data)
                return decodedResponse
            } catch {
                throw NetworkError.decodingError(error)
            }
            
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.networkError(error)
        }
    }
    
    // MARK: - Helper Methods
    private func buildURLRequest<T: NetworkRequest>(from request: T) throws -> URLRequest {
        var urlRequest = URLRequest(url: request.url, timeoutInterval: 30)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        
        // Add headers
        request.headers?.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        // Add default Content-Type for POST/PUT/PATCH if not specified
        if [.POST, .PUT, .PATCH].contains(request.method) &&
           urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return urlRequest
    }
    
    private func validateHTTPResponse(_ response: HTTPURLResponse, data: Data) throws {
        guard 200...299 ~= response.statusCode else {
            let errorMessage = String(data: data, encoding: .utf8)
            throw NetworkError.httpError(response.statusCode, errorMessage)
        }
    }
}

// MARK: - Convenience Request Builders
extension NetworkService {
    
    // Simple GET request
    func get<T: Codable>(from url: URL, type: T.Type, headers: [String: String]? = nil) async throws -> T {
        let request = SimpleRequest<T>(url: url, method: .GET, headers: headers)
        return try await execute(request)
    }
    
    // POST request with body
    func post<T: Codable, U: Codable>(to url: URL, body: U, responseType: T.Type, headers: [String: String]? = nil) async throws -> T {
        let encoder = JSONEncoder()
        let bodyData = try encoder.encode(body)
        let request = SimpleRequest<T>(url: url, method: .POST, headers: headers, body: bodyData)
        return try await execute(request)
    }
    
    // PUT request with body
    func put<T: Codable, U: Codable>(to url: URL, body: U, responseType: T.Type, headers: [String: String]? = nil) async throws -> T {
        let encoder = JSONEncoder()
        let bodyData = try encoder.encode(body)
        let request = SimpleRequest<T>(url: url, method: .PUT, headers: headers, body: bodyData)
        return try await execute(request)
    }
    
    // DELETE request
    func delete<T: Codable>(from url: URL, type: T.Type, headers: [String: String]? = nil) async throws -> T {
        let request = SimpleRequest<T>(url: url, method: .DELETE, headers: headers)
        return try await execute(request)
    }
}

// MARK: - Simple Request Implementation
private struct SimpleRequest<T: Codable>: NetworkRequest {
    typealias ResponseType = T
    
    let url: URL
    let method: HTTPMethod
    let headers: [String: String]?
    let body: Data?
    
    init(url: URL, method: HTTPMethod = .GET, headers: [String: String]? = nil, body: Data? = nil) {
        self.url = url
        self.method = method
        self.headers = headers
        self.body = body

    }
}

// MARK: - Example Usage

// Example Models
struct User: Codable {
    let id: Int
    let name: String
    let email: String
}

struct CreateUserRequest: Codable {
    let name: String
    let email: String
}

struct ApiResponse<T: Codable>: Codable {
    let data: T
    let success: Bool
    let message: String?
}

class GetCharacterRequest: NetworkRequest {
    
    typealias ResponseType = [RMCharacter]
    
    let url: URL
    let method: HTTPMethod = .GET
    let headers: [String: String]? = nil
    let body: Data? = nil
    
    init(name: String) {
        self.url = URL(string: baseAPI + "/character/" + "?=\(name)")!
    }
}

class RickAndMortyApi {
    
    private let networkService = NetworkService()
    
    func character(name: String) async throws -> GetCharacterRequest.ResponseType {
        let request: GetCharacterRequest = GetCharacterRequest(name: name)
        return try await networkService.execute(request)
    }
    
}


// MARK: - Mock URLSession for Testing
class MockURLSession: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        
        guard let data = data, let response = response else {
            throw NetworkError.noData
        }
        
        return (data, response)
    }
}
