//
//  SignupView.swift
//  WordleWarriors
//
//  Created by Nishanth Gopinath on 10/22/24.
//

import UIKit

class SignupView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let nameTextField = UITextField()
    private let nameLabel = UILabel()
    private let emailTextField = UITextField()
    private let emailLabel = UILabel()
    private let passwordTextField = UITextField()
    private let passwordLabel = UILabel()
    let playButton = UIButton(type: .system)
    let cancelButton = UIButton(type: .system)


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
        setupContainerView()
        setupTitleLabel()
        setupNameLabel()
        setupNameTextField()
        setupEmailLabel()
        setupEmailTextField()
        setupPasswordLabel()
        setupPasswordTextField()
        setupPlayButton()
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
        titleLabel.text = "Sign up"
        titleLabel.font = UIFont(name: "AvenirNext-Bold", size: 34)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
    }
    
    //setup name label
    private func setupNameLabel() {
        nameLabel.text = "Name:"
        nameLabel.font = UIFont(name: "AvenirNext-Bold", size: 22)
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
    }
    
    //setup name field
    private func setupNameTextField() {
        nameTextField.font = UIFont.systemFont(ofSize: 18)
        nameTextField.textColor = .black
        nameTextField.backgroundColor = .white
        nameTextField.borderStyle = .none
        nameTextField.layer.cornerRadius = 20
        nameTextField.layer.masksToBounds = true
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameTextField)
    }
    
    //setup email label
    private func setupEmailLabel() {
        emailLabel.text = "Email:"
        emailLabel.font = UIFont(name: "AvenirNext-Bold", size: 22)
        emailLabel.textColor = .white
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emailLabel)
    }
    
    //setup email field
    private func setupEmailTextField() {
        emailTextField.font = UIFont.systemFont(ofSize: 18)
        emailTextField.textColor = .black
        emailTextField.backgroundColor = .white
        emailTextField.borderStyle = .none
        emailTextField.layer.cornerRadius = 20
        emailTextField.layer.masksToBounds = true
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emailTextField)
    }
    
    //setup password label
    private func setupPasswordLabel() {
        passwordLabel.text = "Password:"
        passwordLabel.font = UIFont(name: "AvenirNext-Bold", size: 22)
        passwordLabel.textColor = .white
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(passwordLabel)
    }
    
    //setup password field
    private func setupPasswordTextField() {
        passwordTextField.font = UIFont.systemFont(ofSize: 18)
        passwordTextField.textColor = .black
        passwordTextField.backgroundColor = .white
        passwordTextField.borderStyle = .none
        passwordTextField.layer.cornerRadius = 20
        passwordTextField.layer.masksToBounds = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(passwordTextField)
    }
    
    //setup play button
    private func setupPlayButton() {
        playButton.setTitle("Get Playing!", for: .normal)
        playButton.setTitleColor(.white, for: .normal)
        playButton.backgroundColor = UIColor(red: 102/255, green: 217/255, blue: 178/255, alpha: 1.0)
        playButton.layer.cornerRadius = 20
        playButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(playButton)
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
            containerView.widthAnchor.constraint(equalToConstant: 300),
            containerView.heightAnchor.constraint(equalToConstant: 450),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 25),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            nameTextField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            nameTextField.widthAnchor.constraint(equalToConstant: 250),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            emailLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 5),
            emailLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 25),
            
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor),
            emailTextField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            emailTextField.widthAnchor.constraint(equalToConstant: 250),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 5),
            passwordLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 25),
            
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor),
            passwordTextField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalToConstant: 250),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            playButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 25),
            playButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 250),
            playButton.heightAnchor.constraint(equalToConstant: 50),
            
            cancelButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 5),
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
