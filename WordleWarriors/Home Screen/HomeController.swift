//
//  HomeController.swift
//  WordleWarriors
//
//  Created by Nishanth Gopinath on 11/3/24.
//

import UIKit

class HomeController: UIViewController {
    
    let homeView = HomeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = homeView
        
        homeView.accountButton.addTarget(self, action: #selector(onButtonSettingsTapped), for: .touchUpInside)
        homeView.gameButton.addTarget(self, action: #selector(onButtonPlayTapped), for: .touchUpInside)
        homeView.leaderboardButton.addTarget(self, action: #selector(onButtonLeaderboardTapped), for: .touchUpInside)
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
}
