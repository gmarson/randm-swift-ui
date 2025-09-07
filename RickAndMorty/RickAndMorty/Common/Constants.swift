//
//  Constants.swift
//  RickAndMorty
//
//  Created by Gabriel Marson on 06/09/25.
//

import SwiftUI

// MARK: - Service

let baseAPI: String = "https://rickandmortyapi.com/api/"

// MARK: - UI

extension Color {
    
    static let cellBackground: Color = Color(hex: "35363B")!
    static let background: Color = Color(hex: "23262C")!
    static let softWhite: Color = Color(hex: "F5F5F5")!
    
}

extension Image {
    
    static let notFound: Image = Image(.notFound)
    static let placeHolder: Image = Image(.placeholder)
    
}


// MARK: - Mocks in Preview

extension RMCharacter {
    
    static let rick: RMCharacter = .init(
        id: 1,
        name: "Rick Sanchez",
        status: "Alive",
        species: "Human",
        type: "",
        gender: "Male",
        origin: .init(name: "Earth (C-137)", url: "https://rickandmortyapi.com/api/location/1"),
        location: .init(name: "Citadel of Ricks", url: "https://rickandmortyapi.com/api/location/3"),
        image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
        episode: ["https://rickandmortyapi.com/api/episode/1"],
        url: "https://rickandmortyapi.com/api/character/1",
        created: "2017-11-04T18:48:46.250Z"
    )
    
    static let morty: RMCharacter = .init(
        id: 1,
        name: "Morty Smith",
        status: "Alive",
        species: "Human",
        type: "",
        gender: "Male",
        origin: .init(name: "unknown", url: "https://rickandmortyapi.com/api/location/1"),
        location: .init(name: "Citadel of Ricks", url: "https://rickandmortyapi.com/api/location/3"),
        image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
        episode: ["https://rickandmortyapi.com/api/episode/1"],
        url: "https://rickandmortyapi.com/api/character/2",
        created: "2017-11-04T18:48:46.250Z"
    )
    
    static let alienMorty: RMCharacter = .init(
        id: 1,
        name: "Alien Morty",
        status: "unknown",
        species: "Alien",
        type: "",
        gender: "Male",
        origin: .init(name: "unknown", url: "https://rickandmortyapi.com/api/location/1"),
        location: .init(name: "Citadel of Ricks", url: "https://rickandmortyapi.com/api/location/3"),
        image: "https://rickandmortyapi.com/api/character/avatar/14.jpeg",
        episode: ["https://rickandmortyapi.com/api/episode/10"],
        url: "https://rickandmortyapi.com/api/character/14",
        created: "2017-11-04T18:48:46.250Z"
    )
    
}
