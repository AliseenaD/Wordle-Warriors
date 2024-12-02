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
    
    // Calculate points for the game session
    func calculatePoints(didWin: Bool, attempts: Int, finalTime: String) -> Int {
        var totalPoints = 0
        // Base points if won
        if didWin {
            totalPoints += 100
            // Add the points per attempt
            switch attempts {
            case 1: totalPoints += 50
            case 2: totalPoints += 40
            case 3: totalPoints += 30
            case 4: totalPoints += 20
            case 5: totalPoints += 10
            default: totalPoints += 0
            }
            // Time bonus calculation
            if let seconds = timeStringToSeconds(finalTime) {
                totalPoints += Int(max(0, 100 - seconds / 2))
            }
        }
        else {
            totalPoints = 10
        }
        
        return totalPoints
    }
    
    // Helper function to convert time to seconds
    func timeStringToSeconds(_ timeString: String) -> Double? {
        let components = timeString.components(separatedBy: [":", "."])
        guard components.count == 3,
              let minutes = Double(components[0]),
              let seconds = Double(components[1]),
              let milliseconds = Double(components[2]) else { return nil }
        return minutes * 60 + seconds + milliseconds / 1000
    }
    
    func saveGameState() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("Error: No user is logged in.")
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userID)
        
        // Save the current position
        let gameState: [String: Any] = [
            "startTime": self.startTime?.timeIntervalSince1970 ?? Date().timeIntervalSince1970,
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
            let isGameActive = data?["isGameActive"] as? Bool
            
            // Return if there's no game state to load
            guard let gameState = data?["gameState"] as? [String: Any] else {
                print("No saved game state found.")
                // Load timer state
                self.startTime = Date()
                self.startTimer()
                self.isGameActive = true
                // Update Firestore field to indicate game is active
                userRef.updateData(["isGameActive": true]) { error in
                    if let error = error {
                        print("Error updating game state: \(error.localizedDescription)")
                    } else {
                        print("Game state updated: isGameActive set to true.")
                    }
                }
                return
            }
            
            // If 'dailyGameCompleted' (time last daily game was completed) is not on the same day as 'lastUpdated' (time today's word is created) AND game is not active, then user is playing on a new day
            if let dailyGameCompleted = dailyGameCompleted,
               !self.areDatesOnSameDay(dailyGameCompleted, lastUpdated),
                let isGameActive = isGameActive, !isGameActive{
                print("New day detected. Starting timer.")
                // Update Firestore field to indicate game is active
                userRef.updateData(["isGameActive": true]) { error in
                    if let error = error {
                        print("Error updating game state: \(error.localizedDescription)")
                    } else {
                        print("Game state updated: isGameActive set to true.")
                        // Proceed with starting the game
                        self.startTime = Date()
                        self.startTimer()
                        self.isGameActive = true
                    }
                }
                return
            } else if let dailyGameCompleted = dailyGameCompleted, self.areDatesOnSameDay(dailyGameCompleted, lastUpdated) {
                self.showAlert(message: "User has already played today.")
                self.clearGameState()
                return
            }
            
            // if dailyGameCompleted does NOT exist or if it's not the same day as 'lastUpdated',
            // set isGameActive to True because the user is still playing
            if data?["dailyGameCompleted"] == nil || !self.areDatesOnSameDay(dailyGameCompleted!, lastUpdated) {
                print("User is still playing.")
                self.isGameActive = true
            }
            
            DispatchQueue.main.async {
                // Display timer with appropriate time
                if let savedStartTime = gameState["startTime"] as? TimeInterval {
                    self.startTime = Date(timeIntervalSince1970: savedStartTime)
                } else {
                    // If no start time exists, initialize it as now
                    self.startTime = Date()
                }
                self.startTimer()
                
                // Load current game position
                self.currentRow = gameState["currentRow"] as? Int ?? 0
                self.currentTile = gameState["currentTile"] as? Int ?? 0
                
                // Load tiles state on board
                self.loadTilesAndKeyboardState(gameState: gameState)
            }
        }
    }
    
    func loadTilesAndKeyboardState(gameState: [String: Any]?) {
        // Load tiles state on board
        if let tilesData = gameState?["tilesData"] as? [[String: Any]] {
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
        if let keyboardData = gameState?["keyboardData"] as? [String: String] {
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

    func clearGameState(completion: (() -> Void)? = nil) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("Error: No user is logged in.")
            completion?()
            return
        }
        
        let userRef = Firestore.firestore().collection("users").document(userID)
        
        // Reset the UI and state
        DispatchQueue.main.async {
            self.startTime = nil
            self.stopTimer()
            
            for row in 0..<self.maxGuesses {
                for col in 0..<self.wordLength {
                    let tile = self.boardScreen.tiles[row][col]
                    tile.text = ""
                    tile.backgroundColor = .systemGray6
                    tile.textColor = .black
                }
            }
            
            for row in self.keyboardViewController.keyboardScreen.buttons {
                for button in row {
                    button.backgroundColor = .systemGray5
                    button.setTitleColor(.label, for: .normal)
                }
            }
            
            self.currentRow = 0
            self.currentTile = 0
        }
        
        // Clear Firestore data
        userRef.updateData(["gameState": FieldValue.delete()]) { error in
            if let error = error {
                print("Error clearing game state in Firestore: \(error.localizedDescription)")
            } else {
                print("Game state cleared in Firestore successfully.")
            }
            completion?()
        }
    }
    
    func handleGameCompletion(didWin: Bool, attempts: Int, finalTime: String) {
        self.isGameActive = false // Freeze the keyboard
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let userRef = Firestore.firestore().collection("users").document(userID)
        let leaderboardRef = Firestore.firestore().collection("leaderboard").document("topPlayers")
        // Get the points
        let finalPoints = calculatePoints(didWin: didWin, attempts: attempts, finalTime: finalTime)
        // Update the points on the board screen
        boardScreen.updatePoints(finalPoints)
            
        // Update Firestore with the game result
        let gameID = UUID().uuidString // Generate a unique ID for this game
        let gameData: [String: Any] = [
            "word": targetWord,
            "won": didWin,
            "finalTime": finalTime,
            "attempts": attempts,
            "points": finalPoints,
            "date": FieldValue.serverTimestamp()
        ]
        
        userRef.collection("games").document(gameID).setData(gameData) { error in
            if let error = error {
                print("Error saving game data: \(error.localizedDescription)")
            } else {
                print("Game data saved successfully")
                // Update the user's total points in user collection
                userRef.getDocument { document, error in
                    if let document = document, document.exists {
                        let currentPoints = document.data()?["totalPoints"] as? Int ?? 0
                        userRef.updateData([
                            "totalPoints": currentPoints + finalPoints,
                            "dailyGameCompleted": FieldValue.serverTimestamp(),
                            "isGameActive": false
                        ]) { error in
                            if let error = error {
                                print("Error updating total points or game completed: \(error.localizedDescription)")
                            }
                            else {
                                print("Total points and game completed updated successfully")
                            }
                        }
                    }
                }
            }
        }
        
        // Now update the total points for the user in the leaderboard
        leaderboardRef.getDocument { document, error in
            if let document = document, document.exists,
               let leaderboardData = document.data() {
                // Find the users position
                for (position, value) in leaderboardData {
                    if let playerData = value as? [String: Any],
                       let playerID = playerData["userID"] as? String,
                       playerID == userID {
                        // Get the total score and update it
                        let currentScore = playerData["totalScore"] as? Int ?? 0
                        // Update current position in leaderboard
                        leaderboardRef.updateData([
                            position: [
                                "name": playerData["name"],
                                "totalScore": currentScore + finalPoints,
                                "userID": userID
                            ]
                        ]) { error in
                            if let error = error {
                                print("Error updating leaderboard: \(error.localizedDescription)")
                            }
                            else {
                                print("Successfully updated leaderboard")
                            }
                        }
                        break
                    }
                }
            }
        }
      
        // Reset startTime to 0
        userRef.updateData(["startTime": 0]) { error in
            if let error = error {
                print("Error resetting startTime: \(error.localizedDescription)")
            } else {
                print("startTime reset to 0")
            }
        }
        
        // Display pop-up message
        let message = didWin ? "Congratulations! You won!" : "Game Over! Better luck next time."
        displayPopup(message: message) {
            // Navigate to the appropriate screen after the popup
            if didWin {
                // Delay by 2 seconds before sending to Challenge Screen
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.clearGameState()
                    let challengeController = ChallengeController()
                    challengeController.modalPresentationStyle = .fullScreen
                    self.present(challengeController, animated: true, completion: nil)
                }
            } else {
                // Navigate back to Home Screen if they lost
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.clearGameState() 
                    if let navigationController = self.navigationController {
                        navigationController.popToRootViewController(animated: true)
                    } else {
                        let homeController = HomeController()
                        homeController.modalPresentationStyle = .fullScreen
                        self.present(homeController, animated: true, completion: nil)
                    }
                }
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
    
    // Helper function to display a pop-up
    func displayPopup(message: String, completion: @escaping () -> Void) {
        let popupView = UIView()
        popupView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        popupView.layer.cornerRadius = 12
        popupView.clipsToBounds = true
        popupView.translatesAutoresizingMaskIntoConstraints = false

        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        popupView.addSubview(messageLabel)
        view.addSubview(popupView)

        // Set up constraints for the popup
        NSLayoutConstraint.activate([
            popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            popupView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            popupView.heightAnchor.constraint(equalToConstant: 120),

            messageLabel.centerXAnchor.constraint(equalTo: popupView.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: popupView.centerYAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -16)
        ])

        // Animate the popup appearance and disappearance
        popupView.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            popupView.alpha = 1
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                UIView.animate(withDuration: 0.3, animations: {
                    popupView.alpha = 0
                }) { _ in
                    popupView.removeFromSuperview()
                    completion()
                }
            }
        }
    }
}
