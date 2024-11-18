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
    
    // Timer properties
    var startTime: Date?
    var displayLink: CADisplayLink?
    // To keep track of time if we are resuming a game
    var elapsedTimeBeforePause: TimeInterval = 0
    
    // Game is complete property
    var gameIsComplete = false
    
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
        gameIsComplete = false
        
        // Check if theres a saved game and timer and begin
        loadGameState()
    }
    
    // Loads previous game state
    func loadGameState() {
        let defaults = UserDefaults.standard
        
        // Load the timer state properly
        if let savedElapsedTime = defaults.object(forKey: "elapsedTime") as? TimeInterval {
            elapsedTimeBeforePause = savedElapsedTime
            startTime = Date()
        }
        else {
            // If no saved time then start from 0
            elapsedTimeBeforePause = 0
            startTime = Date()
        }
        startTimer()
        
        // Load current game position
        currentRow = defaults.integer(forKey: "currentRow")
        currentTile = defaults.integer(forKey: "currentTile")
        
        // Load tiles state on board
        if let tilesData = defaults.array(forKey: "tilesData") as? [[String: Any]] {
            var index = 0
            for row in 0..<maxGuesses {
                for col in 0..<wordLength {
                    if index < tilesData.count {
                        let tileData = tilesData[index]
                        let tile = boardScreen.tiles[row][col]
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
        
        // Now also load in the keyboard state
        if let keyboardData = defaults.dictionary(forKey: "keyboardData") as? [String: String] {
            for row in keyboardViewController.keyboardScreen.buttons {
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
    
    // Save the current time of the game as well as all of the guesses
    func saveGameState() {
        let defaults = UserDefaults.standard
        // Save the current time
        let currentElapsedTime = getTotalElapsedTime()
        defaults.set(currentElapsedTime, forKey: "elapsedTime")
        
        // Save the current position
        defaults.set(currentRow, forKey: "currentRow")
        defaults.set(currentTile, forKey: "currentTile")
        
        // Save the state of all of the tiles as well
        var tilesData: [[String: Any]] = []
        for row in boardScreen.tiles {
            for tile in row {
                var tileData: [String: Any] = [
                    "text": tile.text ?? "",
                ]
                
                // Save the state basedon the background color
                if tile.backgroundColor == .systemGreen {
                    tileData["state"] = "correct"
                }
                else if tile.backgroundColor == .systemOrange {
                    tileData["state"] = "wrongPosition"
                }
                else if tile.backgroundColor == .systemRed {
                    tileData["state"] = "wrong"
                }
                else {
                    tileData["state"] = "empty"
                }
                tilesData.append(tileData)
            }
        }
        defaults.set(tilesData, forKey: "tilesData")
        
        // Now also save the keyboard state
        var keyboardData: [String: String] = [:]
        for row in keyboardViewController.keyboardScreen.buttons {
            for button in row {
                if let letter = button.title(for: .normal)?.lowercased() {
                    if button.backgroundColor == .systemGreen {
                        keyboardData[letter] = "correct"
                    } else if button.backgroundColor == .systemOrange {
                        keyboardData[letter] = "wrongPosition"
                    } else if button.backgroundColor == .systemGray {
                        keyboardData[letter] = "wrong"
                    }
                }
            }
        }
        defaults.set(keyboardData, forKey: "keyboardData")
    }
    
    // Function to get the total elapsed time
    func getTotalElapsedTime() -> TimeInterval {
        var totalTime = elapsedTimeBeforePause
        if let startTime = startTime {
            totalTime += Date().timeIntervalSince(startTime)
        }
        return totalTime
    }
    
    @objc private func onBackButtonTapped() {
        stopTimer()
        self.navigationController?.popViewController(animated: true)
    }
    
    // Function to start the timer
    private func startTimer() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateTimer))
        displayLink?.preferredFrameRateRange = CAFrameRateRange(minimum: 60, maximum: 60)
        displayLink?.add(to: .current, forMode: .common)
    }
    
    // Update the timer numbers
    @objc func updateTimer() {
        let totalTime = getTotalElapsedTime()
        let minutes = Int(totalTime) / 60
        let seconds = Int(totalTime) % 60
        let millis = Int((totalTime.truncatingRemainder(dividingBy: 1)) * 1000)
        boardScreen.timerLabel.text = String(format: "%02d:%02d.%03d", minutes, seconds, millis)
        
    }
    
    // Stop the timer
    func stopTimer() {
        let totalTime = getTotalElapsedTime()
        elapsedTimeBeforePause = totalTime
        startTime = nil
        
        displayLink?.invalidate()
        displayLink = nil
        saveGameState()
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
                    // Stop the timer and clear the user default
                    let finalTime = self.boardScreen.timerLabel.text ?? "00:00:00"
                    print("Game completed in: \(finalTime)")
                    // Stop timer and set game is complete to true so that the game will reset after leaving view
                    self.stopTimer()
                    self.gameIsComplete = true
                    
                    // WE WILL NEED TO ADD SOME WINNING FUNCTIONALITY
                } else if self.currentRow >= self.maxGuesses {
                    // Stop timer and set game is complete to true so that the game will reset after leaving view
                    self.stopTimer()
                    self.gameIsComplete = true
                    // WE WILL NEED TO ADD SOME LOSING FUNCTIONALITY
                }
            }
        }
    }
    
    // Clean up when view is going away
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
        // If the game has been completed then reset otherwise save the current state of the game
        if gameIsComplete {
            resetGame()
        }
        else {
            saveGameState()
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
