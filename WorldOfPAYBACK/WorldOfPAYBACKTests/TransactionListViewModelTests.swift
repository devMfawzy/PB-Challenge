//
//  TransactionListViewModelTests.swift
//  WorldOfPAYBACKTests
//
//  Created by Mohamed Fawzy on 23/04/2024.
//

import XCTest
@testable import WorldOfPAYBACK

final class TransactionListViewModelTests: XCTestCase {
    var sut: TransactionListViewModel!
    var service: TransactionsServiceMock!
    var settings: UserSettings!
    
    @MainActor
    override func setUpWithError() throws {
        service = TransactionsServiceMock()
        settings = UserSettings()
        sut = TransactionListViewModel(service:  service, settings: settings)
    }

    override func tearDownWithError() throws {
        sut = nil
        service = nil
        settings = nil
        try super.tearDownWithError()
    }

    @MainActor func test_atFirst_loadState_isIdle() throws {
        XCTAssertEqual(sut.loadState, .idle)
    }
    
    @MainActor func test_whenServer_respondWithError_stateShouldBe_failure() async throws {
        // Given
        let error = TransactionsServiceError.serverError
        service.response = .failure(error)
        
        // When
        sut.loadTransactions()
        try await sut.currentTask?.value

        // Then
        XCTAssertEqual(sut.loadState, .failure(error.localizedDescription))
        XCTAssertFalse(sut.isLoading )
    }
    
    @MainActor func test_whenServer_respondWithSuccess_stateShouldBe_success() async throws {
        // Given
        let transactions = [TransactionItem]()
        service.response = .success(transactions: TransactionList(items: transactions))
        
        // When
        sut.loadTransactions()
        try await sut.currentTask?.value

        // Then
        XCTAssertEqual(sut.loadState, .transactions(transactions))
        XCTAssertFalse(sut.isLoading)

    }
    
    @MainActor func test_whenLoadingTransactions_loadingIdicator_isLoading() async throws {
        // Given
        service.awaitResponseFor(seconds: 1)
        
        // When
        sut.loadTransactions()

        // Then
        XCTAssertTrue(sut.isLoading )
    }
    
    @MainActor func test_whenUpdating_appEnvironment_serviceRelayOnGiven_environment() async throws {
        NetworkEnvironment.allCases.forEach {
            // Given
            let env = $0
            settings.networkEnvironment = $0
            
            // When
            sut.reloadTransactionsOnNetworkChange()
            
            // Then
            XCTAssertEqual(service.environment, env)
        }
    }
    
    @MainActor func test_filtering_transactionsBy_category() async throws {
        // Given
        let categoryIds = [1, 2, 2, 3, 3, 3, 4, 4, 4, 4]
        let transactions = TransactionsServiceMock.randomTansactionsWith(categories: categoryIds)
        
        // When
        service.response = .success(transactions: .init(items: transactions))
        sut.loadTransactions()
        try await sut.currentTask?.value

        // Then
        XCTAssertEqual(sut.allTransactions.count, transactions.count)
        XCTAssertEqual(sut.allTransactions, sut.filteredTransactions)

        // Given
        Set(categoryIds).forEach { id in
            // When
            sut.filterTransactions(by: Category(id: id))
            
            // Then
            XCTAssertTrue(sut.filteredTransactions.allSatisfy { $0.category == id })
        }
        
        // Given
        sut.resetTransactionsFilter()
        
        // Then
        XCTAssertEqual(sut.allTransactions, sut.filteredTransactions)
        XCTAssertNil(sut.selectedCategory)
    }
    
    @MainActor func test_loaded_teansactions_areSortedBy_date_so_newestAtTop() async throws {
        // Given
        let months = [1, 5, 3, 12, 4, 2, 6, 7]
        let transactions = TransactionsServiceMock.randomTansactionsIn(months: months)
        service.response = .success(transactions: TransactionList(items: transactions))
        
        // When
        sut.loadTransactions()
        try await sut.currentTask?.value

        // Then
        let monthsNewstFirst = months.sorted(by: > )
        let expectedMonths = sut.allTransactions.map { Self.monthOf(transaction: $0) }
        XCTAssertEqual(monthsNewstFirst, expectedMonths)
        
        let sortedTransactions = transactions.sorted(by: { $0.transactionDetail.bookingDate > $1.transactionDetail.bookingDate } )
        XCTAssertEqual(sut.allTransactions, sortedTransactions)
    }
}

extension TransactionListViewModelTests {
    static func monthOf(transaction: TransactionItem) -> Int {
        return Calendar.current.component(.month,
                                          from: transaction.transactionDetail.bookingDate)
    }
}
