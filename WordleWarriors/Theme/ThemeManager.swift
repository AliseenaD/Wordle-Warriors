//
//  ThemeManager.swift
//  WordleWarriors
//
//  Created by Nishanth Gopinath on 11/21/24.
//

import Foundation
import UIKit

class ThemeManager {
    static let shared = ThemeManager()

    private init() {}

    var isDarkMode: Bool = false {
        didSet {
            NotificationCenter.default.post(name: .themeChanged, object: nil)
        }
    }
}

extension Notification.Name {
    static let themeChanged = Notification.Name("themeChanged")
}
