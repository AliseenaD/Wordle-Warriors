//
//  HomeView.swift
//  WordleWarriors
//
//  Created by Nishanth Gopinath on 11/3/24.
//

import UIKit

class HomeView: UIView {
    private let gradientLayer = CAGradientLayer()
    private let titleLabel = UILabel()
    private let wordGridImageView = UIImageView()
    let leaderboardButton = UIButton(type: .system)
    let gameButton = UIButton(type: .system)
    let accountButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
        setupTitleLabel()
        setupWordGrid()
        setupLeaderboardButton()
        setupGameButton()
        setupAccountButton()
        observeThemeChanges()
        
        initConstraints()
    }
    
    private func setupAccountButton() {
        accountButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
        accountButton.tintColor = .white
        accountButton.backgroundColor = UIColor(red: 255/255, green: 176/255, blue: 59/255, alpha: 1.0)
        accountButton.layer.cornerRadius = 25
        accountButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(accountButton)
    }
    
    private func setupLeaderboardButton() {
        leaderboardButton.setTitle("View Leaderboard", for: .normal)
        leaderboardButton.setTitleColor(.white, for: .normal)
        leaderboardButton.backgroundColor = UIColor(red: 102/255, green: 217/255, blue: 178/255, alpha: 1.0)
        leaderboardButton.layer.cornerRadius = 20
        leaderboardButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
        leaderboardButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(leaderboardButton)
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

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupTitleLabel() {
        let welcomeText = "Welcome to\nWordle Warriors!"
        let attributedText = NSMutableAttributedString(
            string: welcomeText,
            attributes: [
                .font: UIFont(name: "AvenirNext-Bold", size: 34)!,
                .foregroundColor: UIColor.white
            ]
        )
        
        attributedText.addAttribute(
            .font,
            value: UIFont(name: "AvenirNext-Regular", size: 20)!,
            range: (welcomeText as NSString).range(of: "Welcome to")
        )
        
        titleLabel.attributedText = attributedText
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
    }

    private func setupWordGrid() {
        wordGridImageView.image = UIImage(named: "logo.png")
        wordGridImageView.contentMode = .scaleAspectFit
        wordGridImageView.layer.cornerRadius = 20
        wordGridImageView.layer.masksToBounds = true
        wordGridImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(wordGridImageView)
    }

    private func setupGameButton() {
        gameButton.setTitle("Start a game", for: .normal)
        gameButton.setTitleColor(.white, for: .normal)
        gameButton.backgroundColor = UIColor(red: 255/255, green: 176/255, blue: 59/255, alpha: 1.0)
        gameButton.layer.cornerRadius = 20
        gameButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
        gameButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(gameButton)
    }

    func initConstraints() {
        NSLayoutConstraint.activate([
            accountButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
            accountButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            accountButton.widthAnchor.constraint(equalToConstant: 50),
            accountButton.heightAnchor.constraint(equalToConstant: 50),

            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 80),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),

            wordGridImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            wordGridImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            wordGridImageView.widthAnchor.constraint(equalToConstant: 150),
            wordGridImageView.heightAnchor.constraint(equalToConstant: 150),

            leaderboardButton.topAnchor.constraint(equalTo: wordGridImageView.bottomAnchor, constant: 30),
            leaderboardButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            leaderboardButton.widthAnchor.constraint(equalToConstant: 250),
            leaderboardButton.heightAnchor.constraint(equalToConstant: 50),

            gameButton.topAnchor.constraint(equalTo: leaderboardButton.bottomAnchor, constant: 15),
            gameButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            gameButton.widthAnchor.constraint(equalToConstant: 250),
            gameButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
