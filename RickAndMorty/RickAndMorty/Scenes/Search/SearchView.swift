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
                case .loaded(let characters):
                    List(characters) { character in
                        CharacterView(character: character)
                            .frame(height: 210)
                            .cornerRadius(8)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 8.0, leading: 0.0, bottom: 8.0, trailing: 0.0))
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.background)
                case .error(let message):
                    ContentUnavailableView("Error", systemImage: "exclamationmark.triangle", description: Text(message))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                
                // Customize the search field appearance
                UISearchTextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = Color.softWhite.uiColor
                UISearchTextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(
                    string: "Search characters",
                    attributes: [.foregroundColor: UIColor.lightGray]
                )
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
