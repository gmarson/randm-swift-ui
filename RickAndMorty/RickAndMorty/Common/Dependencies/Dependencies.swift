//
//  Dependencies.swift
//  RickAndMorty
//
//  Created by Gabriel Marson on 07/09/25.
//

import SwiftUI

private struct ClientApiKey: EnvironmentKey {
    static let defaultValue: ClientAPI = RickAndMortyApi()
}

extension EnvironmentValues {
    var clientApi: ClientAPI {
        get { self[ClientApiKey.self] }
        set { self[ClientApiKey.self] = newValue }
    }
}
