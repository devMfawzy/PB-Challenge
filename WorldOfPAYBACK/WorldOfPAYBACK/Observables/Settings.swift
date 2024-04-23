//
//  Settings.swift
//  WorldOfPAYBACK
//
//  Created by Mohamed Fawzy on 23/04/2024.
//

import SwiftUI

class Settings: ObservableObject {
    @AppStorage(AppStorageKeys.networkEnvironment) var networkEnvironment = NetworkEnvironment.mock
}

fileprivate enum AppStorageKeys {
    static var networkEnvironment = "NetworkEnvironment"
}
