//
//  ChallengeView.swift
//  WordleWarriors
//
//  Created by Mohamoud Barre on 11/23/24.
//

import Foundation
import UIKit

class ChallengeView: UIView {
    let gradientLayer = CAGradientLayer()
    let containerView = UIView()
    let titleLabel = UILabel()
    let scoreLabel = UILabel()
    let totalScoreLabel = UILabel()
    let averageScoreLabel = UILabel()
    let cancelButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
        setupContainerView()
        setupTitleLabel()
        setupScoreLabel()
        setupTotalScoreLabel()
        setupAverageScoreLabel()
        setupCancelButton()
        initConstraints()
    }

    private func setupGradient() {
        gradientLayer.colors = [
            UIColor(red: 65/255, green: 176/255, blue: 171/255, alpha: 1.0).cgColor,
            UIColor(red: 149/255, green: 229/255, blue: 182/255, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        layer.insertSublayer(gradientLayer, at: 0)
    }

    private func setupContainerView() {
        containerView.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        containerView.layer.cornerRadius = 20
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
    }

    private func setupTitleLabel() {
        titleLabel.text = "Game Stats"
        titleLabel.font = UIFont(name: "AvenirNext-Bold", size: 28)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
    }

    private func setupScoreLabel() {
        scoreLabel.text = "Current Score:"
        scoreLabel.font = UIFont(name: "AvenirNext-Bold", size: 22)
        scoreLabel.textColor = .white
        scoreLabel.textAlignment = .center
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scoreLabel)
    }

    private func setupTotalScoreLabel() {
        totalScoreLabel.text = "Total Score:"
        totalScoreLabel.font = UIFont(name: "AvenirNext-Bold", size: 22)
        totalScoreLabel.textColor = .white
        totalScoreLabel.textAlignment = .center
        totalScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(totalScoreLabel)
    }

    private func setupAverageScoreLabel() {
        averageScoreLabel.text = "Average Score:"
        averageScoreLabel.font = UIFont(name: "AvenirNext-Bold", size: 22)
        averageScoreLabel.textColor = .white
        averageScoreLabel.textAlignment = .center
        averageScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(averageScoreLabel)
    }

    private func setupCancelButton() {
        cancelButton.setTitle("Return home", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.backgroundColor = UIColor(red: 102/255, green: 217/255, blue: 178/255, alpha: 1.0)
        cancelButton.layer.cornerRadius = 20
        cancelButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(cancelButton)
    }

    func initConstraints() {
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 175),
            containerView.widthAnchor.constraint(equalToConstant: 350),
            containerView.heightAnchor.constraint(equalToConstant: 450),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            scoreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 60),
            scoreLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            totalScoreLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 40),
            totalScoreLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            averageScoreLabel.topAnchor.constraint(equalTo: totalScoreLabel.bottomAnchor, constant: 40),
            averageScoreLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            cancelButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30),
            cancelButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 250),
            cancelButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
