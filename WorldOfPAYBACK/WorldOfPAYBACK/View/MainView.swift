//
//  MainView.swift
//  WorldOfPAYBACK
//
//  Created by Mohamed Fawzy on 22/04/2024.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            TransactionListView()
                .tabItem({
                    Label("Transactions",
                          systemImage: "list.bullet.rectangle.portrait")
                })
            SettingsView()
                .tabItem({
                    Label("Settings",
                          systemImage: "gear")
                })
        }
        .environmentObject(Settings())
    }
}

#Preview {
    MainView()
        .environmentObject(Settings())
}
