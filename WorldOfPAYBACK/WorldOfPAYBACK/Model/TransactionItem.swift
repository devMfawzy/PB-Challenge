//
//  TransactionItem.swift
//  WorldOfPAYBACK
//
//  Created by Mohamed Fawzy on 22/04/2024.
//

import Foundation

struct TransactionItem: Decodable, Identifiable, Equatable {
    var id: String { alias.reference }
    var partnerDisplayName: String
    var alias: Alias
    var category: Int
    var transactionDetail: TransactionDetail
    
    struct Alias: Decodable, Equatable {
        var reference: String
    }
    
    struct TransactionDetail: Decodable, Equatable {
        var description: String?
        var bookingDate: Date
        var value: Value
        
        struct Value: Decodable, Equatable {
            var amount: Double
            var currency: String
        }
    }
}
