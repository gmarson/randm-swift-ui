//
//  SearchViewModel.swift
//  RickAndMorty
//
//  Created by Gabriel Marson on 07/09/25.
//

import Combine
import Foundation

class SearchViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    
}
