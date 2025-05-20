//
//  AddReviewViewModel.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 05. 20..
//

import Foundation
import InjectPropertyWrapper
import Combine

class AddReviewViewModel: ObservableObject, ErrorPresentable {
    @Published var mediaItemDetail: MediaItemDetail = MediaItemDetail()
    @Published var selectedRating: Int = -1
    
    let mediaDetailSubject = PassthroughSubject<MediaItemDetail, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        mediaDetailSubject
            .sink { [weak self]detail in
                self?.mediaItemDetail = detail
            }
            .store(in: &cancellables)
    }
}
