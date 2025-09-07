//
//  Models.swift
//  RickAndMorty
//
//  Created by Gabriel Marson on 07/09/25.
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


// MARK: - Response Data

struct Response<T: Decodable> {
    
    var result: Result<T, NetworkError>
    var urlRequest: URLRequest
    var httpResponse: HTTPURLResponse?
    
    static func failure(error: NetworkError, urlRequest: URLRequest, httpResponse: HTTPURLResponse? = nil) -> Self {
        Response(result: .failure(error), urlRequest: urlRequest, httpResponse: httpResponse)
    }
    
    static func success(object: T, urlRequest: URLRequest, httpResponse: HTTPURLResponse?) -> Self {
        Response(result: .success(object), urlRequest: urlRequest, httpResponse: httpResponse)
    }
    
}

// MARK: - Requests

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

