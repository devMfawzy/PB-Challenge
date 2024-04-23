//
//  TransactionListView.swift
//  WorldOfPAYBACK
//
//  Created by Mohamed Fawzy on 23/04/2024.
//

import SwiftUI

struct TransactionListView: View {
    @EnvironmentObject var settings: Settings
    @StateObject var viewModel = TransactionListViewModel()
    
    public var body: some View {
        transactionsView
    }
    
    @ViewBuilder var transactionsView: some View {
        NavigationView {
            VStack {
                switch viewModel.loadState {
                case .idle:
                    Color.clear
                        .onAppear { viewModel.loadTransactions() }
                case .failure(let message):
                    FailureView(message: message) {
                        viewModel.loadTransactions()
                    }
                case .transactions(let transactions):
                    TransactionsHeaderView(
                        value: viewModel.sumOfTransactions,
                        category: viewModel.selectedCategory) {
                            withAnimation { viewModel.set(selectedCategory: nil) }
                        }
                    List {
                        ForEach(transactions) { transaction in
                            TransactionCellView(transaction: transaction)
                        }
                        .listRowSeparator(.hidden)
                    }
                    .refreshable {
                        viewModel.loadTransactions(showIndicator: false)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Transactions")
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                        .controlSize(.large)
                }
            }
        }
        .onAppear {
            viewModel.update(environment: settings.networkEnvironment)
        }
    }
}

#Preview {
    TransactionListView(viewModel: TransactionListViewModel())
        .environmentObject(Settings())
}
