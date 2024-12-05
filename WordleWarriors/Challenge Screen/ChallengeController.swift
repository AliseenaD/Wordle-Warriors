//
//  ChallengeController.swift
//  WordleWarriors
//
//  Created by Mohamoud Barre on 11/25/24.
//

import UIKit

class ChallengeController: UIViewController {
    var totalScore: Int = 0
    var gamesPlayed: Int = 0
    var averageScore: Double = 0.0

    private var challengeView: ChallengeView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupChallengeView()
        displayScores()
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

        // Set up button action
        challengeView.cancelButton.addTarget(self, action: #selector(returnHome), for: .touchUpInside)
    }

    private func displayScores() {
        // Update the labels with the received score values
        challengeView.totalScoreLabel.text = "Total Score: \(totalScore)"
        challengeView.averageScoreLabel.text = "Average Score: \(String(format: "%.2f", averageScore))"
        challengeView.scoreLabel.text = "Games Played: \(gamesPlayed)"
    }

    @objc private func returnHome() {
        if let navigationController = self.presentingViewController as? UINavigationController {
            self.dismiss(animated: true) {
                for (index, controller) in navigationController.viewControllers.enumerated() {
                    if controller is HomeController {
                        navigationController.popToViewController(navigationController.viewControllers[index], animated: true)
                        return
                    }
                }
            }
        }
    }
}
