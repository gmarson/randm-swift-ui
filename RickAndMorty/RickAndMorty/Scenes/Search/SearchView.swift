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
                setNavigationBarAppeareance()
                setUISearchBarAppeareance()
            }
        }
    }
    
    private func setUISearchBarAppeareance() {
        // Customize the search field appearance
        UISearchTextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = Color.softWhite.uiColor
        UISearchTextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(
            string: "Search characters",
            attributes: [.foregroundColor: UIColor.lightGray]
        )
        
        // Customize the search icon
        UISearchBar.appearance().searchTextPositionAdjustment = UIOffset(horizontal: 0, vertical: 0)
        UISearchBar.appearance().setImage(UIImage(systemName: "magnifyingglass")?.withTintColor(Color.softWhite.uiColor, renderingMode: .alwaysOriginal), for: .search, state: .normal)
        
        // Customize the cancel button
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = Color.softWhite.uiColor
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([
            .foregroundColor: Color.softWhite.uiColor
        ], for: .normal)
    }
    
    private func setNavigationBarAppeareance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Color.background.uiColor
        appearance.titleTextAttributes = [.foregroundColor: Color.softWhite.uiColor]
        appearance.largeTitleTextAttributes = [.foregroundColor: Color.softWhite.uiColor]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    private func contentUnavailableView(title: String, systemImage: String, description: String) -> some View {
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
