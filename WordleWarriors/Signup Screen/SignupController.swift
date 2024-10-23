//
//  SignupController.swift
//  WordleWarriors
//
//  Created by Nishanth Gopinath on 10/22/24.
//

import UIKit

class SignupController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let signupview = SignupView(frame: self.view.bounds)
        self.view = signupview
    }

}
