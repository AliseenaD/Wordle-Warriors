//
//  LeaderboardCell.swift
//  WordleWarriors
//
//  Created by Nishanth Gopinath on 11/19/24.
//

import UIKit

class LeaderboardCell: UITableViewCell {

    private let rankLabel = UILabel()
    private let nameLabel = UILabel()
    private let scoreLabel = UILabel()
    private let containerView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupContainerView()
        setupRankLabel()
        setupNameLabel()
        setupScoreLabel()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
    }

    private func setupContainerView() {
        containerView.backgroundColor = UIColor(red: 253/255, green: 203/255, blue: 88/255, alpha: 1.0)
        containerView.layer.cornerRadius = 10
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
    }

    private func setupRankLabel() {
        rankLabel.font = UIFont(name: "AvenirNext-Bold", size: 16)
        rankLabel.textAlignment = .center
        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(rankLabel)
    }

    private func setupNameLabel() {
        nameLabel.font = UIFont(name: "AvenirNext-Bold", size: 16)
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(nameLabel)
    }

    private func setupScoreLabel() {
        scoreLabel.font = UIFont(name: "AvenirNext-Bold", size: 16)
        scoreLabel.textAlignment = .center
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(scoreLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),

            rankLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            rankLabel.widthAnchor.constraint(equalToConstant: 50),
            rankLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),

            nameLabel.leadingAnchor.constraint(equalTo: rankLabel.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: scoreLabel.leadingAnchor, constant: -10),
            nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),

            scoreLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            scoreLabel.widthAnchor.constraint(equalToConstant: 80),
            scoreLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }

    func configure(rank: Int, name: String, score: Int) {
        rankLabel.text = "\(rank)"
        nameLabel.text = name
        scoreLabel.text = "\(score)"
    }
}
