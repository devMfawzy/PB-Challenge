//
//  UserSettingsMock.swift
//  WorldOfPAYBACKTests
//
//  Created by Mohamed Fawzy on 01/05/2024.
//

import Foundation
@testable import WorldOfPAYBACK

final class UserSettingsMock: UserSettingsProtocol {
    var networkEnvironment: WorldOfPAYBACK.NetworkEnvironment = .mock
    var darkMode: Bool = false
}
