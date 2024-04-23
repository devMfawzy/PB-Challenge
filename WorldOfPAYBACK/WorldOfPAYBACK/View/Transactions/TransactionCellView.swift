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
        HStack {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(transaction.partnerDisplayName)
                        .frame(alignment: .leading)
                    Text(transaction.transactionDetail.description ?? "")
                        .foregroundColor(.gray)
                }
                Text(transaction.transactionDetail.bookingDate.formated)
                    .lineLimit(0)
            }
            Spacer()
            HStack(spacing: 8) {
                Text(transaction.transactionDetail.value.amount, format: .currency(code: transaction.transactionDetail.value.currency))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .dynamicTypeSize(.large)
                    .lineLimit(.zero)
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

