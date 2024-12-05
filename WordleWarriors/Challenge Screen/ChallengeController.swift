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
        challengeView.cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
    }

    // Action for the Cancel button
    @objc func cancelTapped() {
        if let navigationController = self.presentingViewController as? UINavigationController {
            self.dismiss(animated: true) {
                // Look through the stack for HomeController
                for (index, controller) in navigationController.viewControllers.enumerated() {
                    if controller is HomeController {
                        // Pop to that specific HomeController
                        navigationController.popToViewController(navigationController.viewControllers[index], animated: true)
                        return
                    }
                }
            }
        }
    }
}
