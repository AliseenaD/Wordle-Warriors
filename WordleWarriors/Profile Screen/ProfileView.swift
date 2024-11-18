//
//  ProfileView.swift
//  WordleWarriors
//
//  Created by Nishanth Gopinath on 11/16/24.
//

import UIKit

class ProfileView: UIView {

    let gradientLayer = CAGradientLayer()
    let backButton = UIButton(type: .system)
    let profilePhotoButton = UIButton()
    let usernameLabel = UILabel()
    let usernameTextField = UITextField()
    let emailLabel = UILabel()
    let emailValueLabel = UILabel()
    let saveChangesButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
        setupBackButton()
        setupProfilePhotoButton()
        setupUsernameLabel()
        setupUsernameTextField()
        setupEmailLabel()
        setupEmailValueLabel()
        setupSaveChangesButton()
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

    private func setupProfilePhotoButton() {
        profilePhotoButton.setImage(UIImage(systemName: "person.crop.circle.badge.plus"), for: .normal)
        profilePhotoButton.tintColor = .white
        profilePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        profilePhotoButton.layer.cornerRadius = 100
        profilePhotoButton.layer.masksToBounds = true
        profilePhotoButton.backgroundColor = .clear
        profilePhotoButton.imageView?.contentMode = .scaleAspectFit
        profilePhotoButton.contentHorizontalAlignment = .fill
        profilePhotoButton.contentVerticalAlignment = .fill
        addSubview(profilePhotoButton)
    }

    private func setupUsernameLabel() {
        usernameLabel.text = "Username:"
        usernameLabel.font = UIFont(name: "AvenirNext-Bold", size: 22)
        usernameLabel.textColor = .white
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(usernameLabel)
    }

    private func setupUsernameTextField() {
        usernameTextField.font = UIFont.systemFont(ofSize: 18)
        usernameTextField.textColor = .black
        usernameTextField.backgroundColor = .white
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.placeholder = "Current Username" // Placeholder updated dynamically
        usernameTextField.layer.cornerRadius = 10
        usernameTextField.layer.masksToBounds = true
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(usernameTextField)
    }

    private func setupEmailLabel() {
        emailLabel.text = "Email:"
        emailLabel.font = UIFont(name: "AvenirNext-Bold", size: 22)
        emailLabel.textColor = .white
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emailLabel)
    }

    private func setupEmailValueLabel() {
        emailValueLabel.font = UIFont.systemFont(ofSize: 18)
        emailValueLabel.textColor = .white
        emailValueLabel.textAlignment = .left
        emailValueLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emailValueLabel)
    }

    private func setupSaveChangesButton() {
        saveChangesButton.setTitle("Save Changes", for: .normal)
        saveChangesButton.setTitleColor(.white, for: .normal)
        saveChangesButton.backgroundColor = UIColor(red: 255/255, green: 176/255, blue: 59/255, alpha: 1.0)
        saveChangesButton.layer.cornerRadius = 20
        saveChangesButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
        saveChangesButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(saveChangesButton)
    }

    func initConstraints() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5),
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            backButton.heightAnchor.constraint(equalToConstant: 30),

            profilePhotoButton.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20),
            profilePhotoButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            profilePhotoButton.widthAnchor.constraint(equalToConstant: 175),
            profilePhotoButton.heightAnchor.constraint(equalToConstant: 175),

            usernameLabel.topAnchor.constraint(equalTo: profilePhotoButton.bottomAnchor, constant: 20),
            usernameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),

            usernameTextField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 5),
            usernameTextField.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            usernameTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            usernameTextField.heightAnchor.constraint(equalToConstant: 40),

            emailLabel.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20),
            emailLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),

            emailValueLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5),
            emailValueLabel.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),
            emailValueLabel.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor),

            saveChangesButton.topAnchor.constraint(equalTo: emailValueLabel.bottomAnchor, constant: 30),
            saveChangesButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            saveChangesButton.widthAnchor.constraint(equalToConstant: 200),
            saveChangesButton.heightAnchor.constraint(equalToConstant: 50)
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
