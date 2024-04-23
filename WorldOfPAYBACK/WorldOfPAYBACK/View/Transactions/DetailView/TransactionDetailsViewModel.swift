//
//  TransactionDetailsModel.swift
//  WorldOfPAYBACK
//
//  Created by Mohamed Fawzy on 23/04/2024.
//

import Foundation

struct TransactionDetailsViewModel {
    let partnerDisplayName: String
    let transactionDescription: String?
    
    init(partnerDisplayName: String, transactionDescription: String?) {
        self.partnerDisplayName = partnerDisplayName
        self.transactionDescription = transactionDescription
    }
    
    init(transactionItem: TransactionItem) {
        self.partnerDisplayName = transactionItem.partnerDisplayName
        self.transactionDescription = transactionItem.transactionDetail.description
    }
}
