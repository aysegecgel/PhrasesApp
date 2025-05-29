//
//  ContentView.swift
//  EnglishPhrases
//
//  Created by ayse GECGEL on 29.05.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PhrasesViewModel()
    var body: some View {
     NavigationView {
         List(viewModel.filteredPhrases ) { phrase in
                VStack(alignment: .leading, spacing: 4) {
                    Text(phrase.en)
                        .font(.headline)
                    Text(phrase.tr)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.vertical, 4)
                    Divider()
                        .background(Color.gray)
                        .padding(.vertical, 4)
                }
               
            }
            .navigationTitle("Daily English Phrases")
            .searchable(text: $viewModel.searchText, prompt: "Search Phrases")
            .task {
                await viewModel.fetchPhrases()
            }
        }
    }
}

#Preview {
    ContentView()
}
