//
//  UserDefault.swift
//  WorldOfPAYBACK
//
//  Created by Mohamed Fawzy on 25/04/2024.
//

import Foundation

@propertyWrapper
struct UserDefault<Value> {
    let key: UserDefaultKey
    let defaultValue: Value
    var container: UserDefaults = .standard

    var wrappedValue: Value {
        get {
            return container.object(forKey: key.rawValue) as? Value ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key.rawValue)
        }
    }
}

extension UserDefaults {
    @UserDefault(key: .networkEnvironment, defaultValue: NetworkEnvironment.mock.rawValue)
    static var networkEnvironment: String
    
    @UserDefault(key: .darkMode, defaultValue: false)
    static var darkMode: Bool
}

enum UserDefaultKey: String, Codable {
    case networkEnvironment = "UserDefaultKey.NetworkEnvironment"
    case darkMode = "UserDefaultKey.DarkMode"
}
