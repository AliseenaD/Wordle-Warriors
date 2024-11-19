//
//  LeaderboardView.swift
//  WordleWarriors
//
//  Created by Nishanth Gopinath on 11/19/24.
//

import UIKit

class LeaderboardView: UIView {
    let gradientLayer = CAGradientLayer()
    let backButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let headerContainer = UIView()
    private let rankHeaderLabel = UILabel()
    private let nameHeaderLabel = UILabel()
    private let scoreHeaderLabel = UILabel()
    let leaderboardTableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
        setupBackButton()
        setupTitleLabel()
        setupHeader()
        setupLeaderboardTableView()
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
        titleLabel.text = "Leaderboard"
        titleLabel.font = UIFont(name: "AvenirNext-Bold", size: 34)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
    }

    private func setupHeader() {
        // Header container
        headerContainer.backgroundColor = UIColor(red: 255/255, green: 138/255, blue: 58/255, alpha: 1.0)
        headerContainer.layer.cornerRadius = 10
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(headerContainer)
        
        // Rank Header
        rankHeaderLabel.text = "Rank"
        rankHeaderLabel.font = UIFont(name: "AvenirNext-Bold", size: 16)
        rankHeaderLabel.textAlignment = .center
        rankHeaderLabel.textColor = .white
        rankHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(rankHeaderLabel)

        // Name Header
        nameHeaderLabel.text = "Name"
        nameHeaderLabel.font = UIFont(name: "AvenirNext-Bold", size: 16)
        nameHeaderLabel.textAlignment = .center
        nameHeaderLabel.textColor = .white
        nameHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(nameHeaderLabel)

        // Score Header
        scoreHeaderLabel.text = "Score"
        scoreHeaderLabel.font = UIFont(name: "AvenirNext-Bold", size: 16)
        scoreHeaderLabel.textAlignment = .center
        scoreHeaderLabel.textColor = .white
        scoreHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(scoreHeaderLabel)
    }

    private func setupLeaderboardTableView() {
        leaderboardTableView.backgroundColor = .clear
        leaderboardTableView.separatorStyle = .none
        leaderboardTableView.showsVerticalScrollIndicator = false
        leaderboardTableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(leaderboardTableView)
    }

    func initConstraints() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5),
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            backButton.heightAnchor.constraint(equalToConstant: 30),

            titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),

            // Header container constraints
            headerContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            headerContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            headerContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            headerContainer.heightAnchor.constraint(equalToConstant: 50),

            // Rank header constraints
            rankHeaderLabel.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 10),
            rankHeaderLabel.widthAnchor.constraint(equalToConstant: 50),
            rankHeaderLabel.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor),

            // Name header constraints
            nameHeaderLabel.leadingAnchor.constraint(equalTo: rankHeaderLabel.trailingAnchor, constant: 10),
            nameHeaderLabel.trailingAnchor.constraint(equalTo: scoreHeaderLabel.leadingAnchor, constant: -10),
            nameHeaderLabel.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor),

            // Score header constraints
            scoreHeaderLabel.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -10),
            scoreHeaderLabel.widthAnchor.constraint(equalToConstant: 80),
            scoreHeaderLabel.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor),

            // Leaderboard table constraints
            leaderboardTableView.topAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: 10),
            leaderboardTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            leaderboardTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            leaderboardTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20)
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