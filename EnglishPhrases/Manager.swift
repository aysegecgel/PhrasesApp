//
//  Manager.swift
//  EnglishPhrases
//
//  Created by ayse GECGEL on 29.05.2025.
//

import Foundation

class Manager {
    static let shared = Manager()
    
    private init() {}
    
    func fetchPhrases() async throws -> [Phrase] {
        guard let url = URL(string: "https://gist.githubusercontent.com/aysegecgel/670c51afe555e5fee5af4cbd5fb969b9/raw/65b9dae35e149213fa0ef7dc98e38aa14f490adf/gistfile1.txt") else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }

            let (data, response) = try await URLSession.shared.data(from: url)

            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code:", httpResponse.statusCode)
            }

            let decoder = JSONDecoder()
            let decoded = try decoder.decode([Phrase].self, from: data)
            return decoded
        
    }
}

