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
                case .failure(let error):
                    Text("Error view")
                case .transactions(let transactions):
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
            .navigationTitle("transactions")
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
