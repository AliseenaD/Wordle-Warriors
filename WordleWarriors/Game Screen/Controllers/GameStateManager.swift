//
//  GameFirebaseManager.swift
//  WordleWarriors
//
//  Created by Mohamoud Barre on 11/18/24.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth

extension GameBoardViewController{
    func saveGameState() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("Error: No user is logged in.")
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userID)
        
        // Save the current position
        let gameState: [String: Any] = [
            "elapsedTime": elapsedTimeBeforePause,
            "currentRow": currentRow,
            "currentTile": currentTile
        ]
        
        // Save the state of all tiles
        var tilesData: [[String: Any]] = []
        for row in boardScreen.tiles {
            for tile in row {
                var tileData: [String: Any] = [
                    "text": tile.text ?? "",
                ]
                // Save the state based on the background color
                switch tile.backgroundColor {
                case .systemGreen:
                    tileData["state"] = "correct"
                case .systemOrange:
                    tileData["state"] = "wrongPosition"
                case .systemRed:
                    tileData["state"] = "wrong"
                default:
                    tileData["state"] = "empty"
                }
                tilesData.append(tileData)
            }
        }
        
        // Save the keyboard state
        var keyboardData: [String: String] = [:]
        for row in keyboardViewController.keyboardScreen.buttons {
            for button in row {
                if let letter = button.title(for: .normal)?.lowercased() {
                    switch button.backgroundColor {
                    case .systemGreen:
                        keyboardData[letter] = "correct"
                    case .systemOrange:
                        keyboardData[letter] = "wrongPosition"
                    case .systemGray:
                        keyboardData[letter] = "wrong"
                    default:
                        continue
                    }
                }
            }
        }
        
        // Combine all game state data
        var updatedData: [String: Any] = gameState
        updatedData["tilesData"] = tilesData
        updatedData["keyboardData"] = keyboardData
        
        // Save to Firestore
        userRef.updateData(["gameState": updatedData]) { error in
            if let error = error {
                print("Error saving game state: \(error.localizedDescription)")
            } else {
                print("Game state saved successfully.")
            }
        }
    }
    
    // Helper function to check if two dates are on the same day
    func areDatesOnSameDay(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func loadGameState() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("Error: No user is logged in.")
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userID)
        
        userRef.getDocument { document, error in
            if let error = error {
                print("Error loading game state: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists else {
                print("No user data found.")
                return
            }
            
            let data = document.data()
            let lastUpdated = (data?["lastUpdated"] as? Timestamp)?.dateValue() ?? Date.distantPast
            let dailyGameCompleted = (data?["dailyGameCompleted"] as? Timestamp)?.dateValue()
            
            // Return if there's no game state to load (most likely reached if new user)
            guard let gameState = data?["gameState"] as? [String: Any] else {
                print("No saved game state found.")
                self.isGameActive = true
                return
            }
            
            // If 'dailyGameCompleted' (time last daily game was completed) is not on the same day as 'lastUpdated' (time today's word is created), then user is playing new game
            if let dailyGameCompleted = dailyGameCompleted, !self.areDatesOnSameDay(dailyGameCompleted, lastUpdated) {
                print("New day detected. Clearing game state.")
                self.clearGameState()
                self.isGameActive = true
                return
            } else if let dailyGameCompleted = dailyGameCompleted, self.areDatesOnSameDay(dailyGameCompleted, lastUpdated) {
                self.showAlert(message: "User has already played today.")
                return
            }
            
            // if dailyGameCompleted does NOT exist or if it's not the same day as 'lastUpdated',
            // set isGameActive to True because the user is still playing
            if data?["dailyGameCompleted"] == nil {
                print("New user is still playing.")
                self.isGameActive = true
            }else if !self.areDatesOnSameDay(dailyGameCompleted!, lastUpdated) {
                print("User is still playing.")
                self.isGameActive = true
            }
            
            DispatchQueue.main.async {
                // Load timer state
                if let savedElapsedTime = gameState["elapsedTime"] as? TimeInterval {
                    self.elapsedTimeBeforePause = savedElapsedTime
                    self.startTime = Date()
                } else {
                    // If no saved time, start from 0
                    self.elapsedTimeBeforePause = 0
                    self.startTime = Date()
                }
                self.startTimer()
                
                // Load current game position
                self.currentRow = gameState["currentRow"] as? Int ?? 0
                self.currentTile = gameState["currentTile"] as? Int ?? 0
                
                // Load tiles state on board
                if let tilesData = gameState["tilesData"] as? [[String: Any]] {
                    var index = 0
                    for row in 0..<self.maxGuesses {
                        for col in 0..<self.wordLength {
                            if index < tilesData.count {
                                let tileData = tilesData[index]
                                let tile = self.boardScreen.tiles[row][col]
                                // Restore the text
                                tile.text = tileData["text"] as? String
                                // Restore color based on saved state
                                if let state = tileData["state"] as? String {
                                    switch state {
                                    case "correct":
                                        tile.backgroundColor = .systemGreen
                                        tile.textColor = .white
                                    case "wrongPosition":
                                        tile.backgroundColor = .systemOrange
                                        tile.textColor = .white
                                    case "wrong":
                                        tile.backgroundColor = .systemRed
                                        tile.textColor = .white
                                    default:
                                        tile.backgroundColor = .systemGray6
                                        tile.textColor = .black
                                    }
                                }
                            }
                            index += 1
                        }
                    }
                }
                
                // Load keyboard state
                if let keyboardData = gameState["keyboardData"] as? [String: String] {
                    for row in self.keyboardViewController.keyboardScreen.buttons {
                        for button in row {
                            if let letter = button.title(for: .normal)?.lowercased(),
                               let state = keyboardData[letter] {
                                switch state {
                                case "correct":
                                    button.backgroundColor = .systemGreen
                                    button.setTitleColor(.white, for: .normal)
                                case "wrongPosition":
                                    button.backgroundColor = .systemOrange
                                    button.setTitleColor(.white, for: .normal)
                                case "wrong":
                                    button.backgroundColor = .systemGray
                                    button.setTitleColor(.white, for: .normal)
                                default:
                                    button.backgroundColor = .systemGray5
                                    button.setTitleColor(.label, for: .normal)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func clearGameState() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("Error: No user is logged in.")
            return
        }
        
        let userRef = Firestore.firestore().collection("users").document(userID)
        
        DispatchQueue.main.async {
            // Reset the timer
            self.elapsedTimeBeforePause = 0
            self.startTime = nil
            self.stopTimer()
            
            // Clear the board
            for row in 0..<self.maxGuesses {
                for col in 0..<self.wordLength {
                    let tile = self.boardScreen.tiles[row][col]
                    tile.text = ""
                    tile.backgroundColor = .systemGray6
                    tile.textColor = .black
                }
            }
            
            // Clear the keyboard
            for row in self.keyboardViewController.keyboardScreen.buttons {
                for button in row {
                    button.backgroundColor = .systemGray5
                    button.setTitleColor(.label, for: .normal)
                }
            }
            
            // Reset game state variables
            self.currentRow = 0
            self.currentTile = 0
            
            // Clear the user's game state in Firestore
            userRef.updateData([
                "gameState": FieldValue.delete()
            ]) { error in
                if let error = error {
                    print("Error clearing game state in Firestore: \(error.localizedDescription)")
                } else {
                    print("Game state cleared in Firestore successfully.")
                }
            }
        }
    }

    
    func handleGameCompletion(didWin: Bool, attempts: Int, finalTime: String) {
        self.isGameActive = false // Freeze the keyboard
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let userRef = Firestore.firestore().collection("users").document(userID)
        
        // Update Firestore with the game result
        let gameID = UUID().uuidString // Generate a unique ID for this game
        let gameData: [String: Any] = [
            "word": targetWord,
            "won": didWin,
            "finalTime": finalTime,
            "attempts": attempts,
            "date": FieldValue.serverTimestamp()
        ]
        
        userRef.collection("games").document(gameID).setData(gameData) { error in
            if let error = error {
                print("Error saving game data: \(error.localizedDescription)")
            } else {
                print("Game data saved successfully")
            }
        }
        
        // Update Firestore with the game completion timestamp
        userRef.updateData(["dailyGameCompleted": FieldValue.serverTimestamp()]) { error in
            if let error = error {
                print("Error updating dailyGameCompleted: \(error.localizedDescription)")
            } else {
                print("Daily game completion time recorded")
            }
        }
    }
    
    func canStartNewGame(completion: @escaping (Bool) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }
        
        let userRef = Firestore.firestore().collection("users").document(userID)
        userRef.getDocument { snapshot, error in
            if let error = error {
                print("Error checking game eligibility: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            if let data = snapshot?.data() {
                let lastUpdated = (data["lastUpdated"] as? Timestamp)?.dateValue() ?? Date.distantPast
                let dailyGameCompleted = (data["dailyGameCompleted"] as? Timestamp)?.dateValue() ?? Date.distantPast
                
                let canStart = lastUpdated > dailyGameCompleted
                completion(canStart)
                
                if canStart {
                    self.isGameActive = true // Reactivate the keyboard
                }
            } else {
                completion(true)
                self.isGameActive = true // Reactivate the keyboard by default if no data
            }
        }
    }
    
    func fetchOrGenerateDailyWord(completion: @escaping (String?) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(nil) // Handle case where user is not logged in
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userID)
        
        userRef.getDocument { documentSnapshot, error in
            if let error = error {
                print("Error fetching user document: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let document = documentSnapshot, document.exists {
                let data = document.data()
                let lastUpdated = data?["lastUpdated"] as? Timestamp ?? Timestamp(date: Date.distantPast)
                let dailyWord = data?["dailyWord"] as? String ?? ""
                
                // Check if dailyWord is empty or if the word is stale (not updated today)
                let calendar = Calendar.current
                let lastUpdatedDate = lastUpdated.dateValue()
                if dailyWord.isEmpty || !calendar.isDateInToday(lastUpdatedDate) {
                    // Generate a new word and update Firestore
                    self.generateRandomWord { newWord in
                        if let newWord = newWord {
                            userRef.updateData([
                                "dailyWord": newWord,
                                "lastUpdated": FieldValue.serverTimestamp()
                            ]) { error in
                                if let error = error {
                                    print("Error updating daily word: \(error.localizedDescription)")
                                    completion(nil)
                                } else {
                                    completion(newWord)
                                }
                            }
                        } else {
                            completion(nil)
                        }
                    }
                } else {
                    // Use the existing word
                    completion(dailyWord)
                }
            } else {
                // Document doesn't exist; create a new one and generate a word
                self.generateRandomWord { newWord in
                    if let newWord = newWord {
                        userRef.setData([
                            "dailyWord": newWord,
                            "lastUpdated": FieldValue.serverTimestamp()
                        ]) { error in
                            if let error = error {
                                print("Error creating user document: \(error.localizedDescription)")
                                completion(nil)
                            } else {
                                completion(newWord)
                            }
                        }
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }

    func generateRandomWord(completion: @escaping (String?) -> Void) {
        let randomWord = WordManager.shared.generateRandomWord()
        completion(randomWord)
    }
}
