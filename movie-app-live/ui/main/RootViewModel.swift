//
//  RootViewModel.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 05. 16..
//

import Foundation
import InjectPropertyWrapper
import Combine

class RootViewModel: ObservableObject {
    
    @Inject
    private var networkMonitor: NetworkMonitorProtocol
    
    @Published var isConnected: Bool = true
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        networkMonitor.isConnected
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self]isConnected in
                self?.isConnected = isConnected
            })
            .store(in: &cancellables)
    }
}
