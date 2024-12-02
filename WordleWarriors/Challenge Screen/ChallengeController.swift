//
//  ChallengeController.swift
//  WordleWarriors
//
//  Created by Mohamoud Barre on 11/25/24.
//

import UIKit

class ChallengeController: UIViewController {
    private var challengeView: ChallengeView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupChallengeView()
        setupActions()
    }

    private func setupChallengeView() {
        // Initialize and add the ChallengeView
        challengeView = ChallengeView()
        challengeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(challengeView)
        
        // Set up constraints for ChallengeView to fill the entire screen
        NSLayoutConstraint.activate([
            challengeView.topAnchor.constraint(equalTo: view.topAnchor),
            challengeView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            challengeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            challengeView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupActions() {
        // Handle button actions
        challengeView.sendButton.addTarget(self, action: #selector(sendChallengeTapped), for: .touchUpInside)
        challengeView.cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
    }

    // Action for the Send Challenge button
    @objc func sendChallengeTapped() {
        // Logic to send a challenge
        print("Send Challenge tapped")
        // You can add navigation or other logic here
    }

    // Action for the Cancel button
    @objc func cancelTapped() {
        let homeController = HomeController()
        homeController.modalPresentationStyle = .fullScreen
        self.present(homeController, animated: true, completion: nil)
    }
}
