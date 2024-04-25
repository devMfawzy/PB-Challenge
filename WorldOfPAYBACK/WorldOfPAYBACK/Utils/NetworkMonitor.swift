//
//  NetworkMonitor.swift
//  WorldOfPAYBACK
//
//  Created by Mohamed Fawzy on 25/04/2024.
//

import Foundation
import Network

@Observable
final class NetworkMonitor {
    @ObservationIgnored
    private let monitor = NWPathMonitor()
    @ObservationIgnored
    private let queue = DispatchQueue(label: "NetworkMonitor.Queue")

    private(set) var isConnected = true

    init() {
        monitor.pathUpdateHandler =  { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied ? true : false
            }
        }
        monitor.start(queue: queue)
    }
}
