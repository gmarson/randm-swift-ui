//
//  SearchViewModel.swift
//  RickAndMorty
//
//  Created by Gabriel Marson on 07/09/25.
//

import Combine
import Foundation

enum SearchState {
    case idle
    case loading
    case loaded([RMCharacter])
    case error(String)
}

@MainActor
class SearchViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    @Published var state: SearchState = .idle
    
    var characters: [RMCharacter] {
        if case .loaded(let characters) = state {
            return characters
        }
        return []
    }
    
    var service: ClientAPI
    private var cancellables = Set<AnyCancellable>()
    
    init(service: ClientAPI) {
        self.service = service
        setupObservers()
    }
    
    func setupObservers() {
        $searchText
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                guard let self else { return }
                if searchText.isEmpty {
                    self.state = .idle
                } else {
                    Task {
                        await self.search(for: searchText)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func search(for query: String) async {
        state = .loading
        
        let response = await service.character(name: query)
        
        switch response.result {
        case .success(let characters):
            state = .loaded(characters)
        case .failure(let error):
            state = .error(error.localizedDescription)
        }
    }
    
}
