//
//  DetailViewModel.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 05. 09..
//

import Foundation
import InjectPropertyWrapper
import Combine

protocol DetailViewModelProtocol: ObservableObject {
}

class DetailViewModel: DetailViewModelProtocol, ErrorPresentable {
    @Published var mediaItemDetail: MediaItemDetail = MediaItemDetail()
    @Published var alertModel: AlertModel? = nil
    
    let mediaItemIdSubject = PassthroughSubject<Int, Never>()
    
    @Inject
    private var service: ReactiveMoviesServiceProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        let details = mediaItemIdSubject
            .flatMap { [weak self]mediaItemId in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchDetailRequest(mediaId: mediaItemId)
                return self.service.fetchMovieDetail(req: request)
            }
        
        //TODO: credits hívás
        
        details
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            } receiveValue: { [weak self] mediaItemDetail in
                self?.mediaItemDetail = mediaItemDetail
            }
            .store(in: &cancellables)

        
    }
    
}

class DetailViewModel2: DetailViewModelProtocol, ErrorPresentable {
    @Published var alertModel: AlertModel? = nil
    @Published var mediaItem: MediaItemDetail = MediaItemDetail()
    @Published var isFavorite: Bool = false
    
    let mediaItemIdSubject = PassthroughSubject<Int, Never>()
    let favoriteButtonTapped = PassthroughSubject<Void, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    @Inject
    private var service: ReactiveMoviesServiceProtocol
    
    init() {
        mediaItemIdSubject
            .flatMap { [weak self] mediaItemId -> AnyPublisher<MediaItemDetail, MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchDetailRequest(mediaId: mediaItemId)
                return self.service.fetchMovieDetail(req: request)
            }
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            } receiveValue: { [weak self] mediaItem in
                self?.mediaItem = mediaItem
            }
            .store(in: &cancellables)
        
        favoriteButtonTapped
            .flatMap { [weak self] mediaItemId -> AnyPublisher<AddFavoriteResponse, MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = AddFavoriteRequest(movieId: mediaItem.id)
                return service.addFavoriteMovie(req: request)
            }
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            } receiveValue: { [weak self] mediaItem in
                self?.isFavorite.toggle()
            }
            .store(in: &cancellables)
    }
}
