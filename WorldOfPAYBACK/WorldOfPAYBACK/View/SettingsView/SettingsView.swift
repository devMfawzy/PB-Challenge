//
//  SettingsView.swift
//  WorldOfPAYBACK
//
//  Created by Mohamed Fawzy on 23/04/2024.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        NavigationView {
            Form {
                #if DEBUG
                Section {
                    NavigationLink(destination: EnvironmentView()) {
                        HStack {
                            Image(systemName: "hammer.fill")
                                .controlSize(.large)
                            Text("deeveloper_tools")
                            Spacer()
                            Text(settings.networkEnvironment.name)
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                        }
                    }
                }
                #endif
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("settings")
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(Settings())
}
