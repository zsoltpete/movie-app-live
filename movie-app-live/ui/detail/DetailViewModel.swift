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
    @Published var credits: [CastMember] = []
    @Published var isFavorite: Bool = false
    @Published var alertModel: AlertModel? = nil
    
    let mediaItemIdSubject = PassthroughSubject<Int, Never>()
    let favoriteButtonTapped = PassthroughSubject<Void, Never>()
    
    @Inject
    private var service: ReactiveMoviesServiceProtocol
    
    @Inject
    private var favoriteMediaStore: FavoriteMediaStoreProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        
        let mediaItemIdSubject = mediaItemIdSubject.share()
        
        let details = mediaItemIdSubject
            .flatMap { [weak self]mediaItemId in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchDetailRequest(mediaId: mediaItemId)
                return self.service.fetchMovieDetail(req: request)
            }
        
        let credits = mediaItemIdSubject
            .flatMap { [weak self]mediaItemId in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchMovieCreditsRequest(mediaId: mediaItemId)
                return self.service.fetchMovieCredits(req: request)
            }
        
        Publishers.CombineLatest(details, credits)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            } receiveValue: { [weak self] details, credits in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                self.mediaItemDetail = details
                self.credits = credits
                self.isFavorite = self.favoriteMediaStore.isFavoriteMediaItem(withId: details.id)
            }
            .store(in: &cancellables)

        favoriteButtonTapped
            .flatMap { [weak self] _ -> AnyPublisher<(EditFavoriteResult, Bool), MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let isFavorite = !self.isFavorite
                let request = EditFavoriteRequest(movieId: self.mediaItemDetail.id, isFavorite: isFavorite)
                return service.editFavoriteMovie(req: request)
                    .map { result in
                    (result, isFavorite)
                }
                .eraseToAnyPublisher()
            }
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            } receiveValue: { [weak self] result, isFavorite in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                if result.success {
                    self.isFavorite = isFavorite
                    if isFavorite {
                        //self.favoriteMediaStore.addFavoriteMediaItem(self.mediaItemDetail)
                    } else {
                        self.favoriteMediaStore.removeFavoriteMediaItem(withId: self.mediaItemDetail.id)
                    }
                }
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
            .flatMap { [weak self] mediaItemId -> AnyPublisher<EditFavoriteResult, MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = EditFavoriteRequest(movieId: mediaItem.id, isFavorite: true)
                return service.editFavoriteMovie(req: request)
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
