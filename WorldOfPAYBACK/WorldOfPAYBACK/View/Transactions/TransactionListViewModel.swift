//
//  TransactionListViewModel.swift
//  WorldOfPAYBACK
//
//  Created by Mohamed Fawzy on 23/04/2024.
//

import Foundation

@Observable
final class TransactionListViewModel {
    // MARK: - Dependencies
    @ObservationIgnored private(set) var service: TransactionsServiceProtocol
    @ObservationIgnored private(set) var settings: UserSettings
    
    // MARK: - Observation tracked
    private(set) var loadState = LoadState.idle
    private(set) var isLoading = false
    var isFilterViewPresented = false
    
    // MARK: - Init
    init(service: TransactionsServiceProtocol = TransactionsService(),
         settings: UserSettings = UserSettings()) {
        self.service = service
        self.settings = settings
    }
    
    // MARK: - Properies
    @ObservationIgnored private(set) var currentTask: Task<(), Error>?
    @ObservationIgnored private(set) var selectedCategory: Category?
    @ObservationIgnored private(set) var allTransactions = [TransactionItem]()
    var filteredTransactions: [TransactionItem] {
        guard let selectedCategory else {
            return allTransactions
        }
        return allTransactions.filter { Category(id: $0.category) == selectedCategory }
    }
    
    var sumOfTransactions: TransactionItem.TransactionDetail.Value {
        let sum = filteredTransactions.map( { $0.transactionDetail.value.amount } ).reduce(0, +)
        let currency = filteredTransactions.map( { $0.transactionDetail.value.currency } ).first ?? ""
        return .init(amount: sum, currency: currency)
    }
    
    var categories: [Category] {
        let categorieIdsSet = Set<Int>(allTransactions
            .map { $0.category })
        return categorieIdsSet.sorted().map { Category(id: $0) }
    }
    
    // MARK: - Methods
    func loadTransactions(showIndicator: Bool = true) {
        currentTask?.cancel()
        isLoading = showIndicator
        if case .failure = loadState {
            loadState = .idle
        }
        currentTask = Task {
            do {
                let transactions = try await service.getTransactions().sortedByDate
                await handleSuccess(transactions: transactions)
            } catch let error as TransactionsServiceError {
                await handleError(error)
            }
        }
    }
    
    func reloadTransactionsOnNetworkChange() {
        if settings.networkEnvironment != service.environment {
            service.environment = settings.networkEnvironment
            loadTransactions()
        }
    }
    
    func filterTransactions(by category: Category) {
        selectedCategory = category
        loadState = .transactions(filteredTransactions)
    }
    
    func resetTransactionsFilter() {
        selectedCategory = nil
        loadState = .transactions(filteredTransactions)
    }
    
    @MainActor
    private func handleSuccess(transactions: [TransactionItem]) {
        isLoading = false
        selectedCategory = nil
        allTransactions = transactions
        loadState = .transactions(transactions)
    }
    
    @MainActor
    private func handleError(_ error: Error) {
        isLoading = false
        loadState = .failure(error.localizedDescription)
    }
    
    // MARK: - Iner Type
    enum LoadState: Equatable {
        case idle
        case failure(String)
        case transactions([TransactionItem])
    }
}
