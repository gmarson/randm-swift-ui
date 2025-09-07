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
    @Published var characters: [RMCharacter] = []
    
    var service: ClientAPI
    private var cancellables = Set<AnyCancellable>()
    
    init(service: ClientAPI) {
        self.service = service
        setupObservers()
    }
    
    func setupObservers() {
        $searchText
            .throttle(for: .seconds(3), scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] searchText in
                guard let self, !searchText.isEmpty else { return }
                Task {
                    let response = await self.service.character(name: searchText)
                    await MainActor.run {
                        switch response.result {
                        case .success(let characters):
                            self.characters = characters
                        case .failure(let error):
                            break
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
    
}
