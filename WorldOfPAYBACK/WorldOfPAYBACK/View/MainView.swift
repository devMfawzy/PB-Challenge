//
//  MainView.swift
//  WorldOfPAYBACK
//
//  Created by Mohamed Fawzy on 22/04/2024.
//

import SwiftUI

struct MainView: View {
    var settings = UserSettings()

    var body: some View {
        let transactionListViewModel = TransactionListViewModel(settings: settings)
        TabView {
            TransactionListView(viewModel: transactionListViewModel)
                .tabItem({
                    Label("Transactions",
                          systemImage: "list.bullet.rectangle.portrait")
                })
            SettingsView()
                .tabItem({
                    Label("Settings",
                          systemImage: "gear")
                })
                .environment(settings)
        }
        .preferredColorScheme(settings.darkMode ? .dark : .light)
    }
}

#Preview {
    MainView(settings: UserSettings())
        .environment(\.locale, .init(identifier: "de"))
}
