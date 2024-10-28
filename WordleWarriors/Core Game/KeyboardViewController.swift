//
//  KeyboardViewController.swift
//  WordleWarriors
//
//  Created by Ali daeihagh on 10/28/24.
//

import UIKit

// Define the delegate protocol for communication between the game board and the keyboard
protocol KeyboardViewControllerDelegate: AnyObject {
    // Is called when one of the letters is tapped
    func keyboardViewController(_vc: KeyboardViewController, didTapKey letter: Character)
    
    // Is called when the enter button is pressed
    func keyboardViewControllerDidTapEnter(_vc: KeyboardViewController)
    
    // Is called when the backspace button is pressed
    func keyboardViewControllerDidTapBack(_vc: KeyboardViewController)
}

class KeyboardViewController: UIViewController {
    
    var delegate: KeyboardViewControllerDelegate?
    
    let keyboardScreen = KeyboardView()
    
    // Add the keyboard to the controller
    override func loadView() {
        view = keyboardScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonActions()
    }
    
    // Setup the actions for all of the buttons in the keyboard
    func setupButtonActions() {
        for row in keyboardScreen.buttons {
            for button in row {
                button.addTarget(self, action: #selector(keyTapped), for: .touchUpInside)
            }
        }
    }
    
    // Will handle all of the button taps
    @objc func keyTapped(_ sender: UIButton) {
        if let title = sender.title(for: .normal) {
            // Go through and add the appropriate functions for each type of button pressed
            switch title {
            case "ENTER":
                delegate?.keyboardViewControllerDidTapEnter(_vc: self)
            case "⌫":
                delegate?.keyboardViewControllerDidTapBack(_vc: self)
            default:
                let letter = Character(title.lowercased())
                delegate?.keyboardViewController(_vc: self, didTapKey: letter)
            }
        }
    }
    
    // This will update the key colors based on the result
    func updateKey(letter: Character, with state: LetterState) {
        // Find the button for the letter and change its color
        for row in keyboardScreen.buttons {
            for button in row {
                if button.title(for: .normal)?.lowercased() == String(letter) {
                    UIView.animate(withDuration: 0.2) {
                        switch state {
                        case .correct:
                            button.backgroundColor = .systemGreen
                        case .wrongPosition:
                            button.backgroundColor = .systemOrange
                        case .wrong:
                            button.backgroundColor = .systemGray
                        }
                        button.setTitleColor(.white, for: .normal)
                    }
                    return
                }
            }
        }
    }
    
}

enum LetterState {
    case correct
    case wrongPosition
    case wrong
}
