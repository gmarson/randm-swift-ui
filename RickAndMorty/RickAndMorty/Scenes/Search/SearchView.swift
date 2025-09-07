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
            List {
                Text("Search")
                Text("Search")
                Text("Search")
            }
            .searchable(text: $viewModel.searchText, prompt: "Search characters")
            .navigationTitle("Character")
        }
        
    }
}

#Preview {
    SearchView(viewModel: SearchViewModel())
}
