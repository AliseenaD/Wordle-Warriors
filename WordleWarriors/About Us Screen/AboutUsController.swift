//
//  AboutUsController.swift
//  WordleWarriors
//
//  Created by Nishanth Gopinath on 11/17/24.
//

import UIKit

class AboutUsController: UIViewController {
    
    let aboutUsView = AboutUsView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view = aboutUsView
        
        aboutUsView.backButton.addTarget(self, action: #selector(onBackButtonTapped), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
    
    @objc private func onBackButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
