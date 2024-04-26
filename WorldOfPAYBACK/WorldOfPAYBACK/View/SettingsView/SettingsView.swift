//
//  SettingsView.swift
//  WorldOfPAYBACK
//
//  Created by Mohamed Fawzy on 23/04/2024.
//

import SwiftUI

struct SettingsView: View {
    @Environment(UserSettings.self) var settings: UserSettings
    
    var body: some View {
        @Bindable var settings = settings
        NavigationView {
            Form {
                Section("Appearance"){
                    Toggle("Dark", isOn: $settings.darkMode)
                }
                
                #if DEBUG
                Section {
                    NavigationLink(destination: EnvironmentView()) {
                        HStack {
                            Image(systemName: "hammer.fill")
                                .controlSize(.large)
                            Text("Developer tools")
                            Spacer()
                            Text(settings.networkEnvironment.name)
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                        }
                    }
                }
                #endif
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    return SettingsView()
        .environment(UserSettings())
}
