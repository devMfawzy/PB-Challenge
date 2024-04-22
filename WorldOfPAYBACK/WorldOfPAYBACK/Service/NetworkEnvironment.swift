//
//  NetworkEnvironment.swift
//  WorldOfPAYBACK
//
//  Created by Mohamed Fawzy on 22/04/2024.
//

import Foundation

enum NetworkEnvironment: String, CaseIterable, Identifiable {
    case production
    case test
    case mock
    
    var id: Self { self }

    var name: String {
        self.rawValue.capitalized
    }
}

extension NetworkEnvironment {
    var resource: ResourceType {
        switch self {
        case .production: .api("https://api.payback.com/transactions")
        case .test: .api("https://api-test.payback.com/transactions")
        case .mock: .file(Bundle.main.url(forResource: "PBTransactions", withExtension: "json"))
        }
    }
    
    enum ResourceType {
        case api(String)
        case file(URL?)
    }
}
