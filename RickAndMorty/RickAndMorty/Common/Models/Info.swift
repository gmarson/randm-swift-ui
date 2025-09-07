//
//  Info.swift
//  RickAndMorty
//
//  Created by Gabriel Marson on 06/09/25.
//

struct Info: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
