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
    
    init(wrappedValue: Value, key: UserDefaultKey, container: UserDefaults = .standard) {
        self.defaultValue = wrappedValue
        self.key = key
        self.container = container
    }
}

extension UserDefaults {
    @UserDefault(key: .networkEnvironment)
    static var networkEnvironment = NetworkEnvironment.mock.rawValue
    
    @UserDefault(key: .darkMode)
    static var darkMode = false
}

enum UserDefaultKey: String {
    case networkEnvironment = "UserDefaultKey.NetworkEnvironment"
    case darkMode = "UserDefaultKey.DarkMode"
}
