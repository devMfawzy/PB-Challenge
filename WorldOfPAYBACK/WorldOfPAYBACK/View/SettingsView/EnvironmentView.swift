//
//  EnvironmentView.swift
//  WorldOfPAYBACK
//
//  Created by Mohamed Fawzy on 23/04/2024.
//

import SwiftUI

struct EnvironmentView: View {
    @EnvironmentObject var settings: Settings
    
    var body: some View {
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
        .environmentObject(Settings())
}
