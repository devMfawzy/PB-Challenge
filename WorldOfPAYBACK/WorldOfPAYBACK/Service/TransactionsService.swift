//
//  TransactionsService.swift
//  WorldOfPAYBACK
//
//  Created by Mohamed Fawzy on 22/04/2024.
//

import Foundation

protocol TransactionsServiceProtocol {
    func getTransactions() async throws -> TransactionList
    var environment: NetworkEnvironment { get set }
}

enum TransactionsServiceError: Error, LocalizedError, Equatable {
    case invalidUrl
    case decodeError
    case serverError
    
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            "Can't get data, invalid URL."
        case .decodeError:
            "Con't load data, invalid data format."
        case .serverError:
            "Can't connect to server."
        }
    }
}

final class TransactionsService: TransactionsServiceProtocol {
    var environment: NetworkEnvironment = .mock
    
    func getTransactions() async throws -> TransactionList {
        switch environment {
        case .production, .test:
            if case let .api(url) = environment.resource {
                guard let url = URL(string: url) else { throw TransactionsServiceError.invalidUrl }
                return try await getTransactionsFromAPI(url: url)
            }
        case .mock:
            if case let .file(fileURL) = environment.resource, let url = fileURL {
                return try await getTransactionsFromFile(url: url)
            }
        }
        throw TransactionsServiceError.invalidUrl
    }
    
    // MARK: - Private methods
    
    private func getTransactionsFromAPI(url: URL) async throws -> TransactionList {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return try decode(data: data)
        } catch is URLError {
            throw TransactionsServiceError.invalidUrl
        } catch {
            throw TransactionsServiceError.serverError
        }
    }
    
    private func getTransactionsFromFile(url: URL) async throws -> TransactionList {
        let data = try Data(contentsOf: url)
        try await Task.sleep(for: .seconds(1))
        return try decode(data: data)
    }
    
    private func decode(data: Data) throws -> TransactionList {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let jsonData = try decoder.decode(TransactionList.self, from: data)
            return jsonData
        } catch {
            throw TransactionsServiceError.decodeError
        }
    }
}
