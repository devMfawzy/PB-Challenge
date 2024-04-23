//
//  TransactionListViewModel.swift
//  WorldOfPAYBACK
//
//  Created by Mohamed Fawzy on 23/04/2024.
//

import Foundation

@MainActor
final class TransactionListViewModel: ObservableObject {
    // MARK: - Dependencies
    private(set) var service: TransactionsServiceProtocol
    
    // MARK: - Publishers
    @Published private(set) var loadState = LoadState.idle
    @Published private(set) var isLoading = false
    @Published var isFilterViewPresented = false
    
    // MARK: - Init
    init(service: TransactionsServiceProtocol = TransactionsService()) {
        self.service = service
    }
    
    // MARK: - Properies
    private(set) var selectedCategory: Int?
    private var allTransactions = [TransactionItem]()
    private var currentTask: Task<(), Error>?
    private var filteredTransactions: [TransactionItem] {
        guard let selectedCategory else {
            return allTransactions
        }
        return allTransactions.filter { $0.category == selectedCategory }
    }
    
    var sumOfTransactions: TransactionItem.TransactionDetail.Value {
        let sum = filteredTransactions.map( { $0.transactionDetail.value.amount } ).reduce(0, +)
        let currency = filteredTransactions.map( { $0.transactionDetail.value.currency } ).first ?? ""
        return .init(amount: sum, currency: currency)
    }
    
    var categories: [Int] {
        Set<Int>(allTransactions.map( { $0.category } )).sorted()
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
                let transactions = try await service.getTransactions().items.sortByDate()
                handleSuccess(transactions: transactions)
            } catch let error as TransactionsServiceError {
                handleError(error)
            }
        }
    }
    
    func update(environment: NetworkEnvironment) {
        if environment != service.environment {
            service.environment = environment
            loadTransactions()
        }
    }
    
    func set(selectedCategory category: Int?) {
        if selectedCategory != category {
            selectedCategory = category
            loadState = .transactions(filteredTransactions)
        }
    }
    
    private func handleSuccess(transactions: [TransactionItem]) {
        isLoading = false
        selectedCategory = nil
        allTransactions = transactions
        loadState = .transactions(transactions)
    }
    
    private func handleError(_ error: Error) {
        isLoading = false
        loadState = .failure(error.localizedDescription)
    }
    
    // MARK: - Iner Type
    enum LoadState {
        case idle
        case failure(String)
        case transactions([TransactionItem])
    }
}
