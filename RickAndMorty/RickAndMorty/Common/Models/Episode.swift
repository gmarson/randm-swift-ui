//
//  Episode.swift
//  RickAndMorty
//
//  Created by Gabriel Marson on 06/09/25.
//
import Foundation

struct Episode: Decodable {
    
    let id: Int
    let name: String
    let airDate: String
    let episodeNumber: String
    let characters: [String]
    let url: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case airDate = "air_date"
        case episodeNumber = "episode"
        case characters
        case url
        case createdAt = "created"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        airDate = try values.decode(String.self, forKey: .airDate)
        episodeNumber = try values.decode(String.self, forKey: .episodeNumber)
        characters = try values.decode([String].self, forKey: .characters)
        url = try values.decode(String.self, forKey: .url)
        createdAt = try values.decode(String.self, forKey: .createdAt)
    }
    
}
