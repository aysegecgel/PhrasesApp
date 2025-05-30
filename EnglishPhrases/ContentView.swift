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
                 HStack {
                     VStack(alignment: .leading) {
                         Text(phrase.en)
                             .font(.headline)
                         Text(phrase.tr)
                             .font(.subheadline)
                             .foregroundColor(.secondary)
                     }
                     
                     Spacer()
                     
                     Button(action: {
                         viewModel.toggleFavorite(for: phrase)
                     }) {
                         Image(systemName: viewModel.isFavorite(phrase) ? "heart.fill" : "heart")
                             .foregroundColor(.red)
                     }
                     .buttonStyle(.plain)
                     
                 }
                 
                 Divider()
                     .background(Color.gray)
                     .padding(.vertical, 4)
             }
         }
         .toolbar {
             ToolbarItem(placement: .principal) {
                 Text("Daily English Phrases")
                     .font(.title3)
                     .bold()
             }
         }
         
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
