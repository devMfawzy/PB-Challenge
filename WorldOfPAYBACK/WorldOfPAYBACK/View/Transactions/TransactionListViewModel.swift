//
//  TransactionListViewModel.swift
//  WorldOfPAYBACK
//
//  Created by Mohamed Fawzy on 23/04/2024.
//

import Foundation

@Observable
final class TransactionListViewModel {
    // MARK: - Observation Ignored
    @ObservationIgnored private(set) var service: TransactionsServiceProtocol
    @ObservationIgnored private(set) var settings: UserSettingsProtocol
    @ObservationIgnored private(set) var currentTask: Task<(), Error>?
    
    // MARK: - Observation tracked
    private(set) var allTransactions = [TransactionItem]()
    private(set) var isLoading = false
    private(set) var failureMessage: String?
    var isFilterViewPresented = false
    private(set) var selectedCategory: Category?
    var transactions: [TransactionItem] {
        guard let selectedCategory else {
            return allTransactions
        }
        return allTransactions.filter { Category(id: $0.category) == selectedCategory }
    }
    var sumOfTransactions: TransactionItem.TransactionDetail.Value {
        let sum = transactions.map( { $0.transactionDetail.value.amount } ).reduce(0, +)
        let currency = transactions.map( { $0.transactionDetail.value.currency } ).first ?? ""
        return .init(amount: sum, currency: currency)
    }
    var categories: [Category] {
        let categorieIdsSet = Set<Int>(allTransactions
            .map { $0.category })
        return categorieIdsSet.sorted().map { Category(id: $0) }
    }
    var shouldShowFliterView: Bool {
        categories.count > 1
    }
    
    // MARK: - Init
    init(service: TransactionsServiceProtocol = TransactionsService(),
         settings: UserSettingsProtocol = UserSettings()) {
        self.service = service
        self.settings = settings
    }
        
    // MARK: - Methods
    func dispatchAction(action: Action) {
        switch action {
        case .viewWillAppear:
            if allTransactions.isEmpty
                || settings.networkEnvironment != service.environment {
                service.environment = settings.networkEnvironment
                loadTransactions()
            }
        case .showFilterView:
            isFilterViewPresented = true
        case .didResetTransactionsFilter:
            selectedCategory = nil
        case .didPullToRefresh:
            loadTransactions(showIndicator: false)
        case .didTapRetry:
            failureMessage = nil
            loadTransactions()
        case .didSelectCategory(let category):
            selectedCategory = category
        }
    }
    
    private func loadTransactions(showIndicator: Bool = true) {
        currentTask?.cancel()
        isLoading = showIndicator
        failureMessage = nil
        currentTask = Task {
            do {
                let transactions = try await service.getTransactions().sortedByDate
                await handleSuccess(transactions: transactions)
            } catch let error as TransactionsServiceError {
                await handleError(error)
            }
        }
    }
    
    @MainActor
    private func handleSuccess(transactions: [TransactionItem]) {
        isLoading = false
        allTransactions = transactions
        selectedCategory = nil
    }
    
    @MainActor
    private func handleError(_ error: Error) {
        isLoading = false
        failureMessage = error.localizedDescription
        allTransactions.removeAll()
    }
    
    // MARK: - Iner Type
    
    enum Action {
        case viewWillAppear
        case showFilterView
        case didResetTransactionsFilter
        case didPullToRefresh
        case didTapRetry
        case didSelectCategory(category: Category?)
    }
}
