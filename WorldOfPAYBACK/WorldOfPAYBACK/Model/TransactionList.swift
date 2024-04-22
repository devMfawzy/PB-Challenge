//
//  TransactionList.swift
//  WorldOfPAYBACK
//
//  Created by Mohamed Fawzy on 22/04/2024.
//

import Foundation

struct TransactionList: Decodable, Equatable {
    var items: [TransactionItem]
}

extension Array where Element == TransactionItem {
    func sortByDate() -> [TransactionItem] {
        sorted(by: { $0.transactionDetail.bookingDate > $1.transactionDetail.bookingDate } )
    }
}
