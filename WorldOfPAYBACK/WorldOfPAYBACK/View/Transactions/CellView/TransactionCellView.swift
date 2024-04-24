//
//  TransactionCellView.swift
//  WorldOfPAYBACK
//
//  Created by Mohamed Fawzy on 23/04/2024.
//

import SwiftUI

struct TransactionCellView: View {
    let transaction: TransactionItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(transaction.partnerDisplayName)
                    .font(.title)
                    .frame(alignment: .leading)
                Spacer()
                
            }
            Text(transaction.transactionDetail.description ?? "")
                .font(.title3)
                .foregroundColor(.secondary)
            HStack(alignment: .bottom) {
                Text(transaction.transactionDetail.bookingDate.formated)
                    .font(.caption)
                Spacer()
                Text(transaction.transactionDetail.value.amount, format: .currency(code: transaction.transactionDetail.value.currency))
                    .fontWeight(.semibold)
            }
        }
        .foregroundStyle(.black)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.2), radius: 6, x: 0, y: 4)
    }
}

#Preview {
    TransactionCellView(
        transaction: TransactionItem(partnerDisplayName: "Partner display mame",
                        alias: TransactionItem.Alias(reference: "1234"),
                        category: 1,
                        transactionDetail:
                                        TransactionItem.TransactionDetail(
                                            description: "Punkte sammeln",
                                            bookingDate: Date.now,
                                            value:
                                                TransactionItem.TransactionDetail.Value(amount: 22, currency: "EUR")))
    )
    .fixedSize(horizontal: false, vertical: true)
    .padding()
}

