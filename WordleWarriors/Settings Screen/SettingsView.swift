//
//  SettingsView.swift
//  WordleWarriors
//
//  Created by Nishanth Gopinath on 11/3/24.
//

import UIKit

class SettingsView: UIView {
    private let gradientLayer = CAGradientLayer()
    private let titleLabel = UILabel()
    
    let editProfileButton = UIButton(type: .system)
    let darkModeButton = UIButton(type: .system)
    let aboutUsButton = UIButton(type: .system)
    let shareAppButton = UIButton(type: .system)
    let backButton = UIButton(type: .system)

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
        setupTitleLabel()
        setupButtons()
        setupBackButton()
        initConstraints()
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
    
    private func setupGradient() {
        gradientLayer.colors = [
            UIColor(red: 65/255, green: 176/255, blue: 171/255, alpha: 1.0).cgColor,
            UIColor(red: 149/255, green: 229/255, blue: 182/255, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "Settings"
        titleLabel.font = UIFont(name: "AvenirNext-Bold", size: 34)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
    }
    
    private func setupButtons() {
        setupButton(editProfileButton, title: "Edit Profile", imageName: "person.circle")
        setupButton(darkModeButton, title: "Light vs Dark Mode", imageName: "circle.lefthalf.filled")
        setupButton(aboutUsButton, title: "About Us", imageName: "info.circle")
        setupButton(shareAppButton, title: "Share This App", imageName: "square.and.arrow.up")
    }
    
    private func setupButton(_ button: UIButton, title: String, imageName: String) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
        
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        button.setImage(UIImage(systemName: imageName, withConfiguration: symbolConfiguration), for: .normal)
        
        button.tintColor = .black
        button.semanticContentAttribute = .forceLeftToRight
        button.contentHorizontalAlignment = .left
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)
    }

    
    func initConstraints() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5),
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            editProfileButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            editProfileButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            editProfileButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            editProfileButton.heightAnchor.constraint(equalToConstant: 50),
            
            darkModeButton.topAnchor.constraint(equalTo: editProfileButton.bottomAnchor, constant: 20),
            darkModeButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            darkModeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            darkModeButton.heightAnchor.constraint(equalToConstant: 50),
            
            aboutUsButton.topAnchor.constraint(equalTo: darkModeButton.bottomAnchor, constant: 20),
            aboutUsButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            aboutUsButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            aboutUsButton.heightAnchor.constraint(equalToConstant: 50),
            
            shareAppButton.topAnchor.constraint(equalTo: aboutUsButton.bottomAnchor, constant: 20),
            shareAppButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            shareAppButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            shareAppButton.heightAnchor.constraint(equalToConstant: 50)
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
