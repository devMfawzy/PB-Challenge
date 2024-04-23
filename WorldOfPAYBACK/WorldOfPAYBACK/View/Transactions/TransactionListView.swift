//
//  TransactionListView.swift
//  WorldOfPAYBACK
//
//  Created by Mohamed Fawzy on 23/04/2024.
//

import SwiftUI

struct TransactionListView: View {
    @EnvironmentObject var settings: Settings

    var body: some View {
        VStack {
            Text("Transactions")
            Text(settings.networkEnvironment.name)
        }
    }
}

#Preview {
    TransactionListView()
        .environmentObject(Settings())
}
