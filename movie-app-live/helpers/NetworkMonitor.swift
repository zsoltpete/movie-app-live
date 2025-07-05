//
//  NetworkMonitor.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 05. 15..
//

import Foundation
import Reachability
import Combine

protocol NetworkMonitorProtocol {
    var isConnected: AnyPublisher<Bool, Never> { get }
}

class NetworkMonitor: NetworkMonitorProtocol {
    
    var isConnected: AnyPublisher<Bool, Never> {
        isConnectedSubject.eraseToAnyPublisher()
    }
    
    private var reachability: Reachability
    private let isConnectedSubject = CurrentValueSubject<Bool, Never>(true)
    
    init() {
        guard let reachability = try? Reachability() else {
            fatalError("Failed to initialize Reachability")
        }
        
        self.reachability = reachability
        
        reachability.whenReachable = { [weak self]reachability in
            let available = reachability.connection != .unavailable
            self?.isConnectedSubject.send(available)
        }
        reachability.whenUnreachable = { [weak self]_ in
            self?.isConnectedSubject.send(false)
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
}

class NetworkMonitor2: NetworkMonitorProtocol {

    private let reachability: Reachability
    private let isConnectedSubject = CurrentValueSubject<Bool, Never>(true)

    var isConnected: AnyPublisher<Bool, Never> {
        isConnectedSubject.eraseToAnyPublisher()
    }

    init() {
        guard let reachability = try? Reachability() else {
            preconditionFailure("Failed to initialize Reachability")
        }
        self.reachability = reachability
        
        setupReachability()
        start()
    }

    private func setupReachability() {
        reachability.whenReachable = { [weak self] _ in
            self?.isConnectedSubject.send(true)
        }
        reachability.whenUnreachable = { [weak self] _ in
            self?.isConnectedSubject.send(false)
        }
    }

    private func start() {
        do {
            try reachability.startNotifier()
        } catch {
            print("⚠️ Unable to start Reachability notifier: \(error)")
        }
    }
}
