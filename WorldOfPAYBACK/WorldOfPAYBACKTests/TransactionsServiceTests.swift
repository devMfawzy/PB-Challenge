//
//  TransactionsServiceTests.swift
//  WorldOfPAYBACKTests
//
//  Created by Mohamed Fawzy on 22/04/2024.
//

import XCTest
@testable import WorldOfPAYBACK

final class TransactionsServiceTests: XCTestCase {
    var sut: TransactionsServiceMock!

    override func setUp() async throws {
        sut = TransactionsServiceMock()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func test_getTransactions_throws_error_when_repondsWithError() async throws {
        // Given
        sut.response = .failure(.invalidUrl)
        
        // Then
        await XCTAssertThrowsError(
            // When
            try await sut.getTransactions()
        )
    }
    
    func test_getTransactions_success_when_repondsWithData() async throws {
        // Given
        let transactions = TransactionList(items: [])
        sut.response = .success(transactions: transactions)
        
        // When
        let expectedTransactions = try await sut.getTransactions()
        
        // Then
        XCTAssertEqual(expectedTransactions, transactions)
    }
}

extension XCTestCase {
    func XCTAssertThrowsError<T>(_ expression: @autoclosure () async throws -> T) async {
        do {
            _ = try await expression()
            XCTFail("No error was thrown.")
        } catch {
            // passed
        }
    }
}

final class TransactionsServiceMock: TransactionsServiceProtocol {
    var environment: NetworkEnvironment = .mock
    var response: Response = .success(transactions: TransactionList(items: []))
    var expectedData: TransactionList?
    var expectedError: Error?
    
    func getTransactions() async throws -> TransactionList {
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
