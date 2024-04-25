//
//  MainView.swift
//  WorldOfPAYBACK
//
//  Created by Mohamed Fawzy on 22/04/2024.
//

import SwiftUI

struct MainView: View {
    let settings = UserSettings()
    let networkMonitor = NetworkMonitor()
    
    var body: some View {
        VStack(spacing: 0) {
            if !networkMonitor.isConnected {
                ConnectionErrorView(title: "No Internet Connection")
                    .transition(.move(edge: .top))
            }
            tabView
        }
        .animation(.easeOut, value: networkMonitor.isConnected)
    }
    
    // MARK: - Tab view
    private var tabView: some View {
        let transactionListViewModel = TransactionListViewModel(settings: settings)
        return TabView {
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
    MainView()
        .environment(\.locale, .init(identifier: "de"))
}
