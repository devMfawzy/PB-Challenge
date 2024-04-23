//
//  TransactionDetailsView.swift
//  WorldOfPAYBACK
//
//  Created by Mohamed Fawzy on 23/04/2024.
//

import SwiftUI

struct TransactionDetailsView: View {
    var model: TransactionDetailsModel
    
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
    TransactionDetailsView(model: TransactionDetailsModel(partnerDisplayName: "Partner Display Name", transactionDescription: "Transaction description"))
}
