//
//  HomeController.swift
//  WordleWarriors
//
//  Created by Nishanth Gopinath on 11/3/24.
//

import UIKit
import FirebaseAuth

class HomeController: UIViewController {
    
    let homeView = HomeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = homeView
        
        homeView.accountButton.addTarget(self, action: #selector(onButtonSettingsTapped), for: .touchUpInside)
        homeView.gameButton.addTarget(self, action: #selector(onButtonPlayTapped), for: .touchUpInside)
        homeView.leaderboardButton.addTarget(self, action: #selector(onButtonLeaderboardTapped), for: .touchUpInside)
        homeView.logoutButton.addTarget(self, action: #selector(onButtonLogoutTapped), for: .touchUpInside)
    }
    
    @objc func onButtonLogoutTapped() {
        do {
            // Log out from Firebase
            try Auth.auth().signOut()

            let loginScreen = ViewController()
            loginScreen.modalPresentationStyle = .fullScreen
            self.navigationController?.setViewControllers([loginScreen], animated: true)
        } catch let error as NSError {
            print("Error logging out: \(error.localizedDescription)")
            showAlert(message: "Failed to log out. Please try again.")
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
    
    @objc func onButtonPlayTapped() {
        let gameScreen = GameBoardViewController()
        self.navigationController?.pushViewController(gameScreen, animated: true)
    }
    
    @objc func onButtonLeaderboardTapped() {
        let leaderboardScreen = LeaderboardController()
        self.navigationController?.pushViewController(leaderboardScreen, animated: true)
    }
    
    @objc func onButtonSettingsTapped() {
        let settingScreen = SettingsController()
        self.navigationController?.pushViewController(settingScreen, animated: true)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Invalid Input", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
