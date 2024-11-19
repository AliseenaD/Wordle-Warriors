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


    // Example word generation function
    func generateRandomWord(completion: @escaping (String?) -> Void) {
        // Define the API URL
        guard let url = URL(string: "https://random-word-api.herokuapp.com/word?number=1&length=5") else {
            completion(nil)
            return
        }
        
        // Create the URLSession task
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching word: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received.")
                completion(nil)
                return
            }
            
            do {
                // Parse the JSON response, expecting an array of strings
                if let words = try JSONSerialization.jsonObject(with: data, options: []) as? [String],
                   let randomWord = words.first {
                    completion(randomWord) // Return the random word
                } else {
                    print("Unable to parse response.")
                    completion(nil)
                }
            } catch {
                print("JSON parsing error: \(error.localizedDescription)")
                completion(nil)
            }
        }
        
        // Start the task
        task.resume()
    }
    
}

/**
 users
   └── userID (unique for each user, e.g., UID from Firebase Auth)
        ├── dailyWord: "randomWord"      // Word assigned to the user for the day
        ├── games
        │    ├── gameID (unique game session)
        │    │    ├── word: "targetWord"
        │    │    ├── finalTime: "00:03:25"
        │    │    ├── attempts: 4
        │    │    └── challengedBy: "friendID"
        └── totalScore: 1500                    // Accumulated score (optional, if needed)

 challenges  //  Central hub for managing and tracking challenges
   └── challengeID (unique for each challenge)
        ├── sender: "userID"               // User who sent the challenge
        ├── receiver: "friendID"           // User receiving the challenge
        ├── word: "randomWord"             // Word the receiver must solve
        ├── senderFinalTime: "00:03:25"    // Sender's time for the word
        ├── receiverFinalTime: "00:02:50"  // (Optional) Receiver's time, updated after completion
        └── status: "pending"              // Can be "pending", "completed", or "expired"

 leaderboard
   ├── topPlayers
        ├── 1
        │    ├── userID: "userID1"
        │    ├── totalScore: 2300
        │    └── name: "Mo"
        ├── 2
        │    ├── userID: "userID2"
        │    ├── totalScore: 2200
        │    └── username: "Player2"
        └── ...
 */
