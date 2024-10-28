//
//  KeyboardView.swift
//  WordleWarriors
//
//  Created by Ali daeihagh on 10/28/24.
//

import UIKit

class KeyboardView: UIView {

    // Define the letters and buttons to be used
    let letters = [
        ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
        ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
        ["ENTER", "Z", "X", "C", "V", "B", "N", "M", "⌫"]
    ]
    
    var buttons: [[UIButton]] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray // Can change background color later
        
        // Setup the keys
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Function that will setup the keys
    func setupKeys() {
        // Create each of the keyboard rows
        for (i, row) in letters.enumerated() {
            let stackView = UIStackView()
            stackView.spacing = 4
            stackView.distribution = .fillEqually
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            var rowButtons: [UIButton] = []
            
            // Assign a button to each letter for when user presses the letter
            for letter in row {
                let button = UIButton()
                button.setTitle(letter, for: .normal)
                button.setTitleColor(.label, for: .normal)
                button.backgroundColor = .systemGray5
                button.layer.cornerRadius = 5
                button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
                stackView.addArrangedSubview(button)
                rowButtons.append(button)
            }
            
            // Now add each row into the total buttons of keyboard
            buttons.append(rowButtons)
            addSubview(stackView)
            
            NSLayoutConstraint.activate([
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
                stackView.topAnchor.constraint(equalTo: topAnchor, constant: CGFloat(i * 40 + 10))
                ])
        }
    }
    
}
