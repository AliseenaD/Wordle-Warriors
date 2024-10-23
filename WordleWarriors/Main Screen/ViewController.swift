//
//  ViewController.swift
//  WordleWarriors
//
//  Created by Nishanth Gopinath on 10/22/24.
//

import UIKit

class ViewController: UIViewController {
    
    let mainScreen = MainView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = mainScreen
        mainScreen.loginButton.addTarget(self, action: #selector(navigateToLogin), for: .touchUpInside)
        mainScreen.signUpButton.addTarget(self, action: #selector(navigateToSignup), for: .touchUpInside)

    }

    @objc func navigateToLogin() {
        let loginController = LoginController()
        navigationController?.pushViewController(loginController, animated: true)
    }
    
    @objc func navigateToSignup() {
        let SignupController = SignupController()
        navigationController?.pushViewController(SignupController, animated: true)
    }
}

