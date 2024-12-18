//
//  AboutUsView.swift
//  WordleWarriors
//
//  Created by Nishanth Gopinath on 11/17/24.
//

import UIKit

class AboutUsView: UIView {
    let gradientLayer = CAGradientLayer()
    let backButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
        setupBackButton()
        setupTitleLabel()
        setupDescriptionLabel()
        observeThemeChanges()
        initConstraints()
    }

    private func setupGradient() {
        gradientLayer.colors = ThemeManager.shared.isDarkMode ? [
            UIColor(red: 0/255, green: 64/255, blue: 58/255, alpha: 1.0).cgColor, // Dark top
            UIColor(red: 120/255, green: 185/255, blue: 146/255, alpha: 1.0).cgColor // Dark bottom
        ] : [
            UIColor(red: 65/255, green: 176/255, blue: 171/255, alpha: 1.0).cgColor, // Light top
            UIColor(red: 149/255, green: 229/255, blue: 182/255, alpha: 1.0).cgColor // Light bottom
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func observeThemeChanges() {
        NotificationCenter.default.addObserver(self, selector: #selector(onThemeChanged), name: .themeChanged, object: nil)
    }
    
    @objc private func onThemeChanged() {
        gradientLayer.colors = ThemeManager.shared.isDarkMode ? [
            UIColor(red: 0/255, green: 64/255, blue: 58/255, alpha: 1.0).cgColor, // Dark top
            UIColor(red: 120/255, green: 185/255, blue: 146/255, alpha: 1.0).cgColor // Dark bottom
        ] : [
            UIColor(red: 65/255, green: 176/255, blue: 171/255, alpha: 1.0).cgColor, // Light top
            UIColor(red: 149/255, green: 229/255, blue: 182/255, alpha: 1.0).cgColor // Light bottom
        ]
        gradientLayer.frame = bounds
    }
    
    private func setupBackButton() {
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = .white
        backButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
        backButton.semanticContentAttribute = .forceLeftToRight
        backButton.contentHorizontalAlignment = .left
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backButton)
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "About Us"
        titleLabel.font = UIFont(name: "AvenirNext-Bold", size: 34)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.text = "Final Project for CS5520 by Mohamoud Barre, Ali Daeihagh, and Nishanth Gopinath."
        descriptionLabel.font = UIFont(name: "AvenirNext-Bold", size: 20)
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0 // Allow multiline text
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(descriptionLabel)
    }

    func initConstraints() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5),
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10), // Directly under About Us
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
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
