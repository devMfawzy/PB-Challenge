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
        NavigationStack {
            ScrollView {
                LazyVStack(pinnedViews:[.sectionHeaders]) {
                    Section {
                        transactionsList(viewModel.transactions)
                    } header: {
                        viewModel.transactions.ifNotEmpty {
                            TransactionsHeaderView(
                                value: viewModel.sumOfTransactions,
                                category: viewModel.selectedCategory) {
                                    withAnimation {
                                        viewModel.dispatchAction(action: .didResetTransactionsFilter)
                                    }
                                }
                        }
                    }
                }
            }
            .navigationTitle("Transactions")
            .refreshable {
                viewModel.dispatchAction(action: .didPullToRefresh)
            }
            .toolbar {
                if viewModel.shouldShowFliterView {
                    toolBarButton
                }
            }
            .overlay {
                if let message =  viewModel.failureMessage {
                    FailureView(message: message) {
                        viewModel.dispatchAction(action: .didTapRetry)
                    }
                } else if viewModel.isLoading {
                    ProgressView()
                        .controlSize(.large)
                }
            }
        }
        .onAppear {
            viewModel.dispatchAction(action: .viewWillAppear)
        }
    }
    
    private func transactionsList(_ transactions: [TransactionItem]) -> some View {
        ForEach(transactions) { transaction in
            let detailsModel = TransactionDetailsViewModel(transactionItem: transaction)
            NavigationLink(destination: TransactionDetailsView(model: detailsModel)) {
                TransactionCellView(transaction: transaction)
                    .padding(.bottom, 10)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal)
    }
    
    private var toolBarButton: some View {
        Button {
            viewModel.dispatchAction(action: .showFilterView)
        } label: {
            Image(systemName: "slider.horizontal.3")
        }
        .sheet(isPresented: $viewModel.isFilterViewPresented) {
            FilterView(
                selectedCategory: viewModel.selectedCategory,
                categories: viewModel.categories,
                onSelection: { viewModel.dispatchAction(action: .didSelectCategory(category: $0)) }
            )
        }
    }
}

extension Collection {
    @ViewBuilder func ifNotEmpty(_ closure: () -> some View) -> some View {
        if !isEmpty {
            closure()
        }
    }
}

#Preview {
    TransactionListView(viewModel: TransactionListViewModel())
}
