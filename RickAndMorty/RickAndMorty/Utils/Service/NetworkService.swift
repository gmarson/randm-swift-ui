//
//  NetworkError.swift
//  RickAndMorty
//
//  Created by Gabriel Marson on 06/09/25.
//

import Foundation

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
    func execute<T: NetworkRequest>(_ request: T) async -> Response<T.ResponseType> {
        
        let urlRequest = buildURLRequest(from: request)
        let data: Data
        let response: URLResponse
        var httpResponse: HTTPURLResponse?
        
        do {
            (data, response) = try await session.data(for: urlRequest)
            
            guard let http = response as? HTTPURLResponse else {
                return .failure(error: .invalidResponse, urlRequest: urlRequest)
            }
            
            httpResponse = http
            
            try validateHTTPResponse(http, data: data)
            
        } catch {
            return .failure(error: .networkError(error), urlRequest: urlRequest)
        }
           
        do {
            let decodedResponse = try decoder.decode(T.ResponseType.self, from: data)
            return .success(object: decodedResponse, urlRequest: urlRequest, httpResponse: httpResponse)
        } catch {
            return .failure(error: .networkError(error), urlRequest: urlRequest)
        }
        
    }
    
    // MARK: - Helper Methods
    private func buildURLRequest<T: NetworkRequest>(from request: T) -> URLRequest {
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
