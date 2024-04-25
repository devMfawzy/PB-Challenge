//
//  EnvironmentView.swift
//  WorldOfPAYBACK
//
//  Created by Mohamed Fawzy on 23/04/2024.
//

import SwiftUI

struct EnvironmentView: View {
    @Environment(UserSettings.self) var settings: UserSettings
    
    var body: some View {
        @Bindable var settings = settings
        Form {
            Picker("Environment", selection: $settings.networkEnvironment) {
                ForEach(NetworkEnvironment.allCases) {
                    Text($0.name)
                }
            }
            .pickerStyle(.inline)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    EnvironmentView()
        .environment(UserSettings())
}
