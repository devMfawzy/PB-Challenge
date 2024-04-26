//
//  TransactionsHeaderView.swift
//  WorldOfPAYBACK
//
//  Created by Mohamed Fawzy on 23/04/2024.
//

import SwiftUI

struct TransactionsHeaderView: View {
    let value: TransactionItem.TransactionDetail.Value
    let category: Category?
    let onResetFilterTapped: ()->Void
    
    var body: some View {
        VStack {
            HStack {
                Text("Sum")
                    .font(.headline)
                Spacer()
                Text(value.amount,
                     format: .currency(code: value.currency))
                .font(.body)
            }
            if let category {
                HStack {
                    Text("Category:")
                        .font(.headline)
                    Text(category.name)
                        .font(.body)
                    Spacer()
                    Button(action: onResetFilterTapped) {
                        Image(systemName: "x.circle.fill").tint(.gray)
                    }
                }
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(.primary)
        )
        .padding(10)
        .background(.background.opacity(0.98))
    }
}

#Preview {
    TransactionsHeaderView(
        value: .init(amount: 10, currency: "eur"),
        category: .init(id: 5),
        onResetFilterTapped: {})
}
