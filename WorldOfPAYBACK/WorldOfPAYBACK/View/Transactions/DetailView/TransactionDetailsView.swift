//
//  TransactionDetailsView.swift
//  WorldOfPAYBACK
//
//  Created by Mohamed Fawzy on 23/04/2024.
//

import SwiftUI

struct TransactionDetailsView: View {
    var model: TransactionDetailsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(model.partnerDisplayName)
                .font(.title)
            if let description = model.transactionDescription {
                Text(description)
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}

#Preview {
    TransactionDetailsView(model: TransactionDetailsViewModel(partnerDisplayName: "Partner Display Name", transactionDescription: "Transaction description"))
}
