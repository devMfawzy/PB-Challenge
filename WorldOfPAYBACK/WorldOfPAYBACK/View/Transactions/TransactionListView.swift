//
//  TransactionListView.swift
//  WorldOfPAYBACK
//
//  Created by Mohamed Fawzy on 23/04/2024.
//

import SwiftUI

struct TransactionListView: View {
    @State var viewModel: TransactionListViewModel
    
    public var body: some View {
        transactionsView
    }
    
    @ViewBuilder var transactionsView: some View {
        NavigationStack {
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
                            withAnimation { viewModel.resetTransactionsFilter() }
                        }
                    List {
                        ForEach(transactions) { transaction in
                            let detailsModel = TransactionDetailsViewModel(transactionItem: transaction)
                            NavigationLink(destination: TransactionDetailsView(model: detailsModel)) {
                                TransactionCellView(transaction: transaction)
                            }
                        }
                        .listRowSeparator(.hidden)
                    }
                    .refreshable {
                        viewModel.loadTransactions(showIndicator: false)
                    }
                    .toolbar {
                        ToolbarItem {
                            toolBarButton
                        }
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
            viewModel.reloadTransactionsOnNetworkChange()
        }
    }
    
    private var toolBarButton: some View {
        Button {
            viewModel.isFilterViewPresented.toggle()
        } label: {
            Image(systemName: "slider.horizontal.3")
        }
        .sheet(isPresented: $viewModel.isFilterViewPresented) {
            FilterView(
                isPresented: $viewModel.isFilterViewPresented,
                selectedCategory: viewModel.selectedCategory,
                categories: viewModel.categories,
                onSelection: {
                    if let category = $0 {
                        viewModel.filterTransactions(by: category)
                    } else {
                        viewModel.resetTransactionsFilter()
                    }
                } )
        }
    }
}

#Preview {
    TransactionListView(viewModel: TransactionListViewModel())
}
