//
//  SettingsControllerViewController.swift
//  WordleWarriors
//
//  Created by Nishanth Gopinath on 11/3/24.
//

import UIKit

class SettingsController: UIViewController {
    
    let settingsView = SettingsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = settingsView
        
        settingsView.backButton.addTarget(self, action: #selector(onBackButtonTapped), for: .touchUpInside)
        settingsView.editProfileButton.addTarget(self, action: #selector(onProfileButtonTapped), for: .touchUpInside)
        settingsView.aboutUsButton.addTarget(self, action: #selector(onAboutUsButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
    
    @objc private func onBackButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func onProfileButtonTapped() {
        let profileScreen = ProfileViewController()
        self.navigationController?.pushViewController(profileScreen, animated: true)
    }
    
    @objc private func onAboutUsButtonTapped() {
        let aboutUsScreen = AboutUsController()
        self.navigationController?.pushViewController(aboutUsScreen, animated: true)
    }
}
