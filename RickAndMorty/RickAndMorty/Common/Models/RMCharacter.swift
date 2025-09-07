//
//  RMCharacter.swift
//  RickAndMorty
//
//  Created by Gabriel Marson on 06/09/25.
//

import Foundation

struct RMCharacter: Codable {
    
    enum Status: String {
        case alive = "Alive"
        case dead = "Dead"
        case unowned = "Unknown"
    }
    
    let id: Int
    let name: String
    private let status: String
    let species: String
    let type: String
    let gender: String
    let origin: NameAndUrl
    let location: NameAndUrl
    let image: String
    let episode: [String]
    let url: String
    let created: String
    
    var imageData: Data?
    var lifeStatus: Status {
        switch status.lowercased() {
        case "alive": return .alive
        case "dead": return .dead
        default : return .unowned
        }
    }
    
    var firstEpisodeEncounter: String? {
        guard let ep = episode.first else { return nil }
        return ep.digitsAfterLastSlash
    }
    
    #if DEBUG
    
    init(id: Int, name: String, status: String, species: String, type: String, gender: String, origin: NameAndUrl, location: NameAndUrl, image: String, episode: [String], url: String, created: String, imageData: Data? = nil) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.type = type
        self.gender = gender
        self.origin = origin
        self.location = location
        self.image = image
        self.episode = episode
        self.url = url
        self.created = created
        self.imageData = imageData
    }
    
    #endif
    
}

extension RMCharacter {
    var stringId: String { "\(id)" }
}


