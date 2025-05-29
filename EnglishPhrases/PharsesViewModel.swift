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
    private var cancellables: Set<AnyCancellable> = []
    
    init () {
        bindSearchText()
    }

   func fetchPhrases() async {
       
           do {
               let phrase = try await Manager.shared.fetchPhrases()
               phrases = phrase
               filteredPhrases = phrase
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
         }

