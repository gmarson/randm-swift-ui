//
//  ClientAPI.swift
//  RickAndMorty
//
//  Created by Gabriel Marson on 07/09/25.
//

import Foundation

protocol ClientAPI {
    func character(name: String) async -> Response<GetCharacterRequest.ResponseType>
}

class RickAndMortyApi: ClientAPI {
    
    private let networkService = NetworkService()
    
    func character(name: String) async -> Response<GetCharacterRequest.ResponseType> {
        let request: GetCharacterRequest = GetCharacterRequest(name: name)
        return await networkService.execute(request)
    }
    
}

#if DEBUG

class ClientAPIDebug: ClientAPI {
    
    func character(name: String) async -> Response<GetCharacterRequest.ResponseType> {
        let object: [RMCharacter] = [.alienMorty]
        let url: URL = URL(string: baseAPI)!
        let urlRequest: URLRequest = URLRequest(url: url)
        return .success(object: object, urlRequest: urlRequest, httpResponse: nil)
    }
    
}

#endif
