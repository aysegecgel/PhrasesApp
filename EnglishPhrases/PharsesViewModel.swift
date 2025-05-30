//
//  PharsesViewModel.swift
//  EnglishPhrases
//
//  Created by ayse GECGEL on 29.05.2025.
//

import Foundation
import Combine

@MainActor

class PhrasesViewModel: ObservableObject {
    
    @Published var phrases: [Phrase] = []
    @Published var searchText: String = ""
    @Published var filteredPhrases: [Phrase] = []
    @Published var favoriteIDs: Set<Int> = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init () {
        bindSearchText()
//        loadFavoriteIDs()
    }

   func fetchPhrases() async {
       
           do {
               let phrase = try await Manager.shared.fetchPhrases()
               phrases = phrase
               filteredPhrases = phrase
               loadFavoriteIDs()
           } catch {
               print("Error fetching data: \(error.localizedDescription)")
           }
        }
    func bindSearchText() {
        $searchText
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.filterPhrases(with: searchText)
            }
            .store(in: &cancellables)
    }
    
    func filterPhrases(with text: String) {
                if text.isEmpty {
                    filteredPhrases = phrases
                } else {
                    filteredPhrases = phrases.filter {
                        $0.en.localizedCaseInsensitiveContains(text) ||
                        $0.tr.localizedCaseInsensitiveContains(text)
                    }
                }
            }
    func toggleFavorite(for phrase: Phrase) {
        if favoriteIDs.contains(phrase.id) {
            favoriteIDs.remove(phrase.id)
        } else {
            favoriteIDs.insert(phrase.id)
        }
        saveFavoriteIDs()
    }
    
    func saveFavoriteIDs() {
        UserDefaults.standard.set(Array(favoriteIDs), forKey: "favoriteIDs")
    }
    
    func isFavorite(_ phrase: Phrase) -> Bool {
        favoriteIDs.contains(phrase.id)
    }
    
    private func loadFavoriteIDs() {
        if let savedIDs = UserDefaults.standard.array(forKey: "favoriteIDs") as? [Int] {
            favoriteIDs = Set(savedIDs)
        }
    }
}

