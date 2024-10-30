//
//  LoginController.swift
//  WordleWarriors
//
//  Created by Nishanth Gopinath on 10/22/24.
//

import UIKit
import FirebaseAuth

class LoginController: UIViewController {

    let loginView = LoginView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = loginView
        loginView.playButton.addTarget(self, action: #selector(onButtonPlayTapped), for: .touchUpInside)
    }
    
    @objc func onButtonPlayTapped() {
            if let email = self.loginView.emailTextField.text,
               let password = self.loginView.passwordTextField.text {
                self.signInToFirebase(email: email, password: password)
            } else {
                self.showAlert(message: "Please enter both email and password.")
            }
    }
    
    func signInToFirebase(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error as NSError? {
                let errorMessage = error.localizedDescription
                self.showAlert(message: errorMessage)
            } else {
                print("User authenticated successfully")
                self.clearSignupFields()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Authentication Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    func clearSignupFields(){
        loginView.emailTextField.text = ""
        loginView.passwordTextField.text = ""
    }

}
