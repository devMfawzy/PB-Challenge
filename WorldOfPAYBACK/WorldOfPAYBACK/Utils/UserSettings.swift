//
//  Settings.swift
//  WorldOfPAYBACK
//
//  Created by Mohamed Fawzy on 23/04/2024.
//

import Foundation

@Observable
class UserSettings {
    var networkEnvironment = NetworkEnvironment(rawValue: UserDefaults.networkEnvironment) ?? .mock {
        didSet {
            UserDefaults.networkEnvironment = networkEnvironment.rawValue
        }
    }
    
    var darkMode = UserDefaults.darkMode {
        didSet {
            UserDefaults.darkMode = darkMode
        }
    }
}
