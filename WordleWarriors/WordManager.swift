//
//  WordManager.swift
//  WordleWarriors
//
//  Created by Mohamoud Barre on 11/19/24.
//

import Foundation

class WordManager {
    static let shared = WordManager() // Singleton instance
    
    private var validWords: Set<String> = []
    
    // Private init ensures no external instantiation
    private init() {
        loadWords()
    }

    // Function to load words from the local file into a Set
    private func loadWords() {
        guard let fileURL = Bundle.main.url(forResource: "words", withExtension: "txt") else {
            print("Error: words.txt not found")
            return
        }
        
        do {
            let words = try String(contentsOf: fileURL)
            let wordList = words.split(whereSeparator: \.isNewline) // Split words by newlines
            validWords = Set(wordList.map { $0.lowercased() }) // Add words to the Set (case-insensitive)
        } catch {
            print("Error reading words.txt: \(error.localizedDescription)")
        }
    }
    
    // Function to check if a word is valid
    func isValidWord(_ word: String) -> Bool {
        return validWords.contains(word.lowercased()) // Case-insensitive check
    }

    // Function to generate a random word
    func generateRandomWord() -> String? {
        return validWords.randomElement()
    }
}
