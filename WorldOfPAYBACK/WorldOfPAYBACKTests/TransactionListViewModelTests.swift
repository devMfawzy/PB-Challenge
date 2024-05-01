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
    var settings: UserSettingsMock!
    
    @MainActor override func setUpWithError() throws {
        service = TransactionsServiceMock()
        settings = UserSettingsMock()
        sut = TransactionListViewModel(service:  service, settings: settings)
    }

    override func tearDownWithError() throws {
        sut = nil
        service = nil
        settings = nil
        try super.tearDownWithError()
    }

    @MainActor func test_initial_state() throws {
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.isFilterViewPresented)
        XCTAssertNil(sut.failureMessage)
        XCTAssertNil(sut.selectedCategory)
        XCTAssertTrue(sut.transactions.isEmpty)
        XCTAssertEqual(sut.sumOfTransactions, .init(amount: 0, currency: ""))
        XCTAssertTrue(sut.categories.isEmpty)
    }
    
    @MainActor func test_whenServer_respondWithError_stateShouldBe_failure() async throws {
        // Given
        let error = TransactionsServiceError.serverError
        service.response = .failure(error)
        
        // When
        sut.dispatchAction(action: .viewWillAppear)
        try await sut.currentTask?.value

        // Then
        XCTAssertEqual(sut.failureMessage, error.localizedDescription)
        XCTAssertFalse(sut.isLoading )
    }
    
    @MainActor func test_whenServer_respondWithSuccess_stateShouldBe_success() async throws {
        // Given
        let transactions = [TransactionItem]()
        service.response = .success(transactions: TransactionList(items: transactions))
        
        // When
        sut.dispatchAction(action: .viewWillAppear)
        XCTAssertTrue(sut.isLoading)
        try await sut.currentTask?.value

        // Then
        XCTAssertNil(sut.failureMessage)
        XCTAssertEqual(sut.transactions, transactions)
        XCTAssertFalse(sut.isLoading)
    }
    
    @MainActor func test_when_viewWillAppear_isLoading() async throws {
        // Given
        service.awaitResponseFor(seconds: 2)
        
        // When
        sut.dispatchAction(action: .viewWillAppear)

        // Then
        XCTAssertTrue(sut.isLoading)
    }
    
    @MainActor func test_when_pullToRefresh_LoadingIndicator_isNotShown() async throws {
        // Given
        service.awaitResponseFor(seconds: 2)
        
        // When
        sut.dispatchAction(action: .didPullToRefresh)

        // Then
        XCTAssertFalse(sut.isLoading)
    }
    
    @MainActor func test_whenUpdating_appEnvironment_serviceRelayOnGiven_environment() async throws {
        [NetworkEnvironment.production, .test].forEach {
            // Given
            settings.networkEnvironment = $0

            // When
            sut.dispatchAction(action: .viewWillAppear)
            
            // Then
            XCTAssertEqual(service.environment, $0)
            service.environment = .mock // reset
        }
    }
    
    @MainActor func test_didTapRetry() async throws {
        // Given
        service.response = .failure(.serverError)
        
        // When
        sut.dispatchAction(action: .viewWillAppear)
        try await sut.currentTask?.value
        
        // Then
        XCTAssertEqual(sut.failureMessage, TransactionsServiceError.serverError.errorDescription)

        // Given
        let transactions = TransactionsServiceMock.randomTansactions(count: 1)
        service.response = .success(transactions: .init(items: transactions))
        
        // When
        sut.dispatchAction(action: .didTapRetry)
        try await sut.currentTask?.value
        
        // Then
        XCTAssertEqual(sut.transactions, transactions)
        XCTAssertNil(sut.failureMessage)
    }
    
    @MainActor func test_showFilterView() async throws {
        // When
        sut.dispatchAction(action: .showFilterView)
        
        //then
        XCTAssertTrue(sut.isFilterViewPresented)
    }
    
    @MainActor func test_filtering_transactionsBy_category() async throws {
        // Given
        let categoryIds = [1, 2, 2, 3, 3, 3, 4, 4, 4, 4]
        let transactions = TransactionsServiceMock.randomTansactionsWith(categories: categoryIds)
        
        // When
        service.response = .success(transactions: .init(items: transactions))
        sut.dispatchAction(action: .viewWillAppear)
        try await sut.currentTask?.value

        // Then
        XCTAssertEqual(sut.transactions.count, transactions.count)

        // Given
        Set(categoryIds).forEach { id in
            // When
            sut.dispatchAction(action: .didSelectCategory(category:Category(id: id)))
            
            // Then
            XCTAssertTrue(sut.transactions.allSatisfy { $0.category == id })
        }
        
        // Given
        sut.dispatchAction(action: .didResetTransactionsFilter)
        
        // Then
        XCTAssertEqual(sut.allTransactions, sut.transactions)
        XCTAssertNil(sut.selectedCategory)
    }
    
    @MainActor func test_whenLoaded_transactionsWithSingleCategory_shouldNotShowFliterView() async throws {
        // Given
        let categoryIds = [3, 3, 3]
        let transactions = TransactionsServiceMock.randomTansactionsWith(categories: categoryIds)
        
        // When
        service.response = .success(transactions: .init(items: transactions))
        sut.dispatchAction(action: .viewWillAppear)
        try await sut.currentTask?.value
        
        // then
        XCTAssertFalse(sut.shouldShowFliterView)
    }
    
    @MainActor func test_whenLoaded_transactionsWithDifferentCategories_shouldShowFliterView() async throws {
        // Given
        let categoryIds = [2, 3]
        let transactions = TransactionsServiceMock.randomTansactionsWith(categories: categoryIds)
        
        // When
        service.response = .success(transactions: .init(items: transactions))
        sut.dispatchAction(action: .viewWillAppear)
        try await sut.currentTask?.value
        
        // then
        XCTAssertTrue(sut.shouldShowFliterView)
    }
    
    @MainActor func test_loaded_teansactions_areSortedBy_date_so_newestAtTop() async throws {
        // Given
        let months = [1, 5, 3, 12, 4, 2, 6, 7]
        let transactions = TransactionsServiceMock.randomTansactionsIn(months: months)
        service.response = .success(transactions: TransactionList(items: transactions))
        
        // When
        sut.dispatchAction(action: .viewWillAppear)
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
