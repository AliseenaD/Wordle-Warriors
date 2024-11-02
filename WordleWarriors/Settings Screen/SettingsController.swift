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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
    
    @objc private func onBackButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
