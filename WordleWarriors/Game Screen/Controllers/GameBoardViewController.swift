//
//  GameBoardViewController.swift
//  WordleWarriors
//
//  Created by Ali daeihagh on 10/28/24.
//

import Foundation
import UIKit

class GameBoardViewController: UIViewController {

    // Properties for the controller
    let wordLength = 5
    let maxGuesses = 6
    var currentRow = 0
    var currentTile = 0
    var targetWord = "swift" // WILL HAVE TO FIX THIS TO MAKE IT RANDOM AT SOME POINT
    
    var keyboardViewController: KeyboardViewController!
    let boardScreen = GameBoardView()
    
    override func loadView() {
        view = boardScreen
        
        // Hide the back button
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .lightGray
        
        // Initialize the keyboard controller and set up delegation
        keyboardViewController = KeyboardViewController()
        keyboardViewController.delegate = self
        
        // Setup the keyboard
        setupKeyboard()
        
        // Reset the game state
        currentRow = 0
        currentTile = 0
    }
    
    // Setup the keyboard
    func setupKeyboard() {
        // Add the keyboard controller as the child
        addChild(keyboardViewController)
        view.addSubview(keyboardViewController.view)
        keyboardViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup the constraints for the keyboard
        NSLayoutConstraint.activate([
            keyboardViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            keyboardViewController.view.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        keyboardViewController.didMove(toParent: self)
    }

    // Function that will get the current word that we are on
    func getCurrWord() -> String {
        // Condense the whole row of tiles into one word
        let word = boardScreen.tiles[currentRow].compactMap { $0.text }.joined()
        return word.lowercased()
    }
    
    // Function to check if a word is valid using the Free Dictionary API
    func isValidWord(_ word: String, completion: @escaping (Bool) -> Void) {
        // Construct the URL
        guard let url = URL(string: "https://api.dictionaryapi.dev/api/v2/entries/en/\(word)") else {
            completion(false)
            return
        }
        
        // Create the data task
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Check for error or no data
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            // Attempt to decode the JSON response
            do {
                // Parse the JSON data
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]], !jsonArray.isEmpty {
                    // The response contains word data
                    completion(true)
                } else {
                    // The response is empty or invalid
                    completion(false)
                }
            } catch {
                // If decoding fails, consider it as an invalid word
                completion(false)
            }
        }
        
        // Start the data task
        task.resume()
    }

    // Function to show an alert
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Try Again", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    // Function that checks the current guess
    func checkGuess() {
        let guess = getCurrWord()
        
        // Make sure guess is the correct length
        if guess.count != wordLength {
            return
        }
        
        // Check if the guessed word is valid
        isValidWord(guess) { isValid in
            DispatchQueue.main.async {
                if !isValid {
                    self.showAlert(message: "Not in word list")
                    return
                }

                // Track the letter states and the counts
                var letterStates = Array(repeating: LetterState.wrong, count: self.wordLength)
                var targetLetterCounts = [Character: Int]()
                
                // Count all of the letters in the target word
                for char in self.targetWord {
                    targetLetterCounts[char, default: 0] += 1
                }
                
                // Check for correct positions
                for (index, letter) in guess.enumerated() {
                    // If letter is correct and in correct position then assign correct to the letter state
                    if letter == self.targetWord[self.targetWord.index(self.targetWord.startIndex, offsetBy: index)] {
                        letterStates[index] = .correct
                        targetLetterCounts[letter]! -= 1
                    }
                }
                
                // Check for correct letter but wrong position
                for (index, letter) in guess.enumerated() {
                    // Mark as incorrect position if not in right spot
                    if letterStates[index] != .correct && targetLetterCounts[letter, default: 0] > 0 {
                        letterStates[index] = .wrongPosition
                        targetLetterCounts[letter]! -= 1
                    }
                }
                
                // Now update the UI with all of the results
                for (index, state) in letterStates.enumerated() {
                    let tile = self.boardScreen.tiles[self.currentRow][index]
                    let letter = guess[guess.index(guess.startIndex, offsetBy: index)]
                    
                    // Provide animation for the color changes
                    UIView.animate(withDuration: 0.3, delay: Double(index) * 0.2) {
                        switch state {
                        case .correct:
                            tile.backgroundColor = .systemGreen
                        case .wrongPosition:
                            tile.backgroundColor = .systemOrange
                        case .wrong:
                            tile.backgroundColor = .systemRed
                        }
                        tile.textColor = .white
                    }
                    
                    // Update the keyboard text colors
                    self.keyboardViewController.updateKey(letter: letter, with: state)
                }
                
                // Now move to the next row
                self.currentRow += 1
                self.currentTile = 0
                
                // Check if user won or lost
                if guess == self.targetWord {
                    // WE WILL NEED TO ADD SOME WINNING FUNCTIONALITY
                } else if self.currentRow >= self.maxGuesses {
                    // WE WILL NEED TO ADD SOME LOSING FUNCTIONALITY
                }
            }
        }
    }
}

extension GameBoardViewController: KeyboardViewControllerDelegate {
    // Functionality for each key press
    func keyboardViewController(_vc: KeyboardViewController, didTapKey letter: Character) {
        // Validation step
        if currentRow >= maxGuesses || currentTile > wordLength {
            return
        }
        let tile = boardScreen.tiles[currentRow][currentTile]
        tile.text = String(letter).uppercased()
        currentTile += 1
    }
    
    // Check functionality when enter is pressed
    func keyboardViewControllerDidTapEnter(_vc: KeyboardViewController) {
        // If current tile not equal to word length then do nothing
        if currentTile != wordLength {
            return
        }
        // Check word
        checkGuess()
    }
    
    // Functionality for delete button
    func keyboardViewControllerDidTapBack(_vc: KeyboardViewController) {
        // Do nothing if current tile is at start
        if currentTile <= 0 {
            return
        }
        // Otherwise move tile back one and reset the letter
        currentTile -= 1
        boardScreen.tiles[currentRow][currentTile].text = ""
    }
}
