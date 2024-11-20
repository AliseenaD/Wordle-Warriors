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
    var targetWord = ""
    
    // Timer properties
    var startTime: Date?
    var displayLink: CADisplayLink?
    // To keep track of time if we are resuming a game
    var elapsedTimeBeforePause: TimeInterval = 0
    var isGameActive = false
    var keyboardViewController: KeyboardViewController!
    let boardScreen = GameBoardView()
    
    override func loadView() {
        view = boardScreen
        
        // Hide the back button
        self.navigationItem.hidesBackButton = true
        
        boardScreen.backButton.addTarget(self, action: #selector(onBackButtonTapped), for: .touchUpInside)
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
        
        // Check if theres a saved game and timer and begin
        loadGameState()
        
        // Fetch or generate the daily word for the user
        fetchOrGenerateDailyWord { [weak self] word in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let word = word {
                    self.targetWord = word
                    print("Daily word set to: \(word)")
                } else {
                    self.showAlert(message: "Failed to load daily word. Please try again later.")
                }
            }
        }
    }
    
    // Reset the game
    func resetGame() {
        // Clear saved game state
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "elapsedTime")
        defaults.removeObject(forKey: "currentRow")
        defaults.removeObject(forKey: "currentTile")
        defaults.removeObject(forKey: "tilesData")
        defaults.removeObject(forKey: "keyboardData")
        
        // Reset timer values
        elapsedTimeBeforePause = 0
        startTime = nil
        boardScreen.timerLabel.text = "00:00.000"
        
        // Reset game position
        currentRow = 0
        currentTile = 0
        
        // Reset all tile colors and text
        for row in boardScreen.tiles {
            for tile in row {
                tile.backgroundColor = .systemGray6
                tile.textColor = .black
                tile.text = ""
            }
        }
        
        // Reset all keyboard buttons
        for row in keyboardViewController.keyboardScreen.buttons {
            for button in row {
                button.backgroundColor = .systemGray5
                button.setTitleColor(.label, for: .normal)
            }
        }
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
        let isValid = WordManager.shared.isValidWord(guess)
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
                // Stop the timer and clear the user default
                let finalTime = self.boardScreen.timerLabel.text ?? "00:00:00"
                print("Game completed in: \(finalTime)")
                // Stop timer and set game is complete to true so that the game will reset after leaving view
                self.stopTimer()
                self.handleGameCompletion(didWin: true, attempts: self.currentRow, finalTime: finalTime)
            } else if self.currentRow >= self.maxGuesses {
                let finalTime = self.boardScreen.timerLabel.text ?? "00:00:00"
                // Stop timer and set game is complete to true so that the game will reset after leaving view
                self.stopTimer()
                self.handleGameCompletion(didWin: false, attempts: self.currentRow, finalTime: finalTime)
            }
        }
    }
    
    // Clean up when view is going away
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }
}

extension GameBoardViewController: KeyboardViewControllerDelegate {
    func keyboardViewController(_vc: KeyboardViewController, didTapKey letter: Character) {
        // Check if the game is active
        guard isGameActive else { return }
        
        // Validation step
        if currentRow >= maxGuesses || currentTile >= wordLength {
            return
        }
        let tile = boardScreen.tiles[currentRow][currentTile]
        tile.text = String(letter).uppercased()
        currentTile += 1
    }
    
    func keyboardViewControllerDidTapEnter(_vc: KeyboardViewController) {
        // Check if the game is active
        guard isGameActive else { return }
        
        // If current tile not equal to word length then do nothing
        if currentTile != wordLength {
            return
        }
        // Check word
        checkGuess()
    }
    
    func keyboardViewControllerDidTapBack(_vc: KeyboardViewController) {
        // Check if the game is active
        guard isGameActive else { return }
        
        // Do nothing if current tile is at start
        if currentTile <= 0 {
            return
        }
        // Otherwise move tile back one and reset the letter
        currentTile -= 1
        boardScreen.tiles[currentRow][currentTile].text = ""
    }
}

