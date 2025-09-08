//
//  SearchView.swift
//  RickAndMorty
//
//  Created by Gabriel Marson on 07/09/25.
//

import SwiftUI

struct SearchView: View {
    
    @StateObject var viewModel: SearchViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .idle:
                    contentUnavailableView(title: "Search Characters", systemImage: "magnifyingglass", description: "Enter a character name to search")
                case .loading:
                    ProgressView("Searching...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .loaded(let characters):
                    List(characters) { character in
                        CharacterView(character: character)
                            .frame(maxWidth: .infinity)
                            .frame(height: 210)
                            .cornerRadius(8)
                            .listRowBackground(Color.clear)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .scrollContentBackground(.hidden)
                    .background(Color.background)
                case .error(let message):
                    ContentUnavailableView("Error", systemImage: "exclamationmark.triangle", description: Text(message))
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Search characters")
            .navigationTitle("Character")
            .navigationBarTitleDisplayMode(.large)
            .background(Color.background)
            .onAppear {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithTransparentBackground()
                appearance.titleTextAttributes = [.foregroundColor: Color.softWhite.uiColor]
                appearance.largeTitleTextAttributes = [.foregroundColor: Color.softWhite.uiColor]
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
                
                // Customize the text color of the search field
                UISearchTextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = .softWhite
                // Customize the placeholder text color
                let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.lightGray]
                UISearchTextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search", attributes: attributes)
            }
        }
    }
    
    
    func contentUnavailableView(title: String, systemImage: String, description: String) -> some View {
        ContentUnavailableView(
            title,
            systemImage: systemImage,
            description: Text(description)
        ).foregroundStyle(Color.softWhite)
    }
    
}

#Preview {
    SearchView(viewModel: SearchViewModel(service: ClientAPIDebug()))
}
