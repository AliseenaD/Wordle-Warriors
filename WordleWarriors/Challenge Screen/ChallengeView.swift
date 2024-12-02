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
    let chooseOpponentLabel = UILabel()
    var searchBar: UISearchBar!
    let scoreLabel = UILabel()
    let sendButton = UIButton(type: .system)
    let cancelButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
        setupContainerView()
        setupTitleLabel()
        setupChooseOpponentLabel()
        setupScoreLabel()
        setupSearchBar()
        setupSendButton()
        setupCancelButton()

        initConstraints()
    }

    //setup background
    private func setupGradient() {
        gradientLayer.colors = [
            UIColor(red: 65/255, green: 176/255, blue: 171/255, alpha: 1.0).cgColor,
            UIColor(red: 149/255, green: 229/255, blue: 182/255, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    //setup grey box
    private func setupContainerView() {
        containerView.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        containerView.layer.cornerRadius = 20
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
    }
    
    //setup title
    private func setupTitleLabel() {
        titleLabel.text = "Challenge a Friend?"
        titleLabel.font = UIFont(name: "AvenirNext-Bold", size: 28)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
    }
    
    //setup opponent label
    private func setupChooseOpponentLabel() {
        chooseOpponentLabel.text = "Choose Oppenent:"
        chooseOpponentLabel.font = UIFont(name: "AvenirNext-Bold", size: 22)
        chooseOpponentLabel.textColor = .white
        chooseOpponentLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(chooseOpponentLabel)
    }
    
    func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.placeholder = "To:"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(searchBar)
    }
    
    //setup score label
    private func setupScoreLabel() {
        scoreLabel.text = "Score to beat:"
        scoreLabel.font = UIFont(name: "AvenirNext-Bold", size: 22)
        scoreLabel.textColor = .white
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scoreLabel)
    }
    
    //setup play button
    private func setupSendButton() {
        sendButton.setTitle("Send Challenge", for: .normal)
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.backgroundColor = UIColor(red: 102/255, green: 217/255, blue: 178/255, alpha: 1.0)
        sendButton.layer.cornerRadius = 20
        sendButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sendButton)
    }
    
    //setup cancel button
    private func setupCancelButton() {
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.backgroundColor = UIColor(red: 255/255, green: 176/255, blue: 59/255, alpha: 1.0)
        cancelButton.layer.cornerRadius = 20
        cancelButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(cancelButton)
    }


    func initConstraints(){
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 175),
            containerView.widthAnchor.constraint(equalToConstant: 350),
            containerView.heightAnchor.constraint(equalToConstant: 450),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            chooseOpponentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 80),
            chooseOpponentLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 25),
            
            searchBar.topAnchor.constraint(equalTo: chooseOpponentLabel.bottomAnchor),
            searchBar.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            searchBar.widthAnchor.constraint(equalToConstant: 250),
            searchBar.heightAnchor.constraint(equalToConstant: 40),
            
            scoreLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            scoreLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 25),
            
            sendButton.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 25),
            sendButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 250),
            sendButton.heightAnchor.constraint(equalToConstant: 50),
            
            cancelButton.topAnchor.constraint(equalTo: sendButton.bottomAnchor, constant: 5),
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
