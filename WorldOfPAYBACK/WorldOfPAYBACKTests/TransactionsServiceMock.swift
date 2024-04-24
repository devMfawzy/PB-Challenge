//
//  TransactionsServiceMock.swift
//  WorldOfPAYBACKTests
//
//  Created by Mohamed Fawzy on 23/04/2024.
//

import Foundation
@testable import WorldOfPAYBACK

final class TransactionsServiceMock: TransactionsServiceProtocol {
    var environment: NetworkEnvironment = .mock
    var response: Response = .success(transactions: TransactionList(items: []))
    var expectedData: TransactionList?
    var expectedError: Error?
    private var responInSecond: UInt64?
    
    func getTransactions() async throws -> TransactionList {
        if let seconds = responInSecond {
            try await Task.sleep(nanoseconds: UInt64(1e+9) * seconds)
        }
        switch response {
        case .failure(let error):
            throw error
        case .success(let transactions):
            return transactions
        }
    }
    
    enum Response {
        case failure(TransactionsServiceError)
        case success(transactions: TransactionList)
    }
}

extension TransactionsServiceMock {
    func awaitResponseFor(seconds: UInt64) {
        responInSecond = seconds
    }
    
    
    static func randomTansactionsWith(categories: [Int]) -> [TransactionItem] {
        randomTansactionsWith(numbers: categories)
    }
    
    static func randomTansactionsIn(months: [Int]) -> [TransactionItem] {
        randomTansactionsWith(numbers: months)
    }
    
    private static func randomTansactionsWith(numbers: [Int]) -> [TransactionItem] {
        func dateIn(month: Int) -> Date {
            let dateComponents = DateComponents(year: 2024, month: month, day: 1)
            return Calendar.current.date(from: dateComponents) ?? Date.now
        }
        
        return numbers.map {
            TransactionItem(partnerDisplayName: "name \($0)",
                            alias: TransactionItem.Alias(reference: "\($0)\($0)"),
                            category: $0,
                            transactionDetail: TransactionItem.TransactionDetail(
                                bookingDate: dateIn(month: $0),
                                value: .init(amount: Double($0) * 10.0,
                                             currency: "EUR")
                            ))
        }.shuffled()
    }
}
