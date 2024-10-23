//
//  LoginController.swift
//  WordleWarriors
//
//  Created by Nishanth Gopinath on 10/22/24.
//

import UIKit

class LoginController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let loginView = LoginView(frame: self.view.bounds)
        self.view = loginView
    }
}
