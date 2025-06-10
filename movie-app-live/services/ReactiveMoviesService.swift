//
//  ReactiveMoviesService.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 05. 06..
//

import Foundation
import Moya
import InjectPropertyWrapper
import Combine
import Alamofire

protocol MovieRepository {
    func fetchGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError>
    func fetchTVGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError>
    func searchMovies(req: SearchMovieRequest) -> AnyPublisher<[MediaItem], MovieError>
    func fetchMovies(req: FetchMediaListRequest) -> AnyPublisher<MediaItemPage, MovieError>
    func fetchTV(req: FetchMediaListRequest) -> AnyPublisher<MediaItemPage, MovieError>
    func fetchFavoriteMovies(req: FetchFavoriteMovieRequest, fromLocal: Bool) -> AnyPublisher<[MediaItem], MovieError>
    func editFavoriteMovie(req: EditFavoriteRequest) -> AnyPublisher<EditFavoriteResult, MovieError>
    func fetchMovieDetail(req: FetchDetailRequest) -> AnyPublisher<MediaItemDetail, MovieError>
    func fetchMovieCredits(req: FetchMovieCreditsRequest) -> AnyPublisher<[CastMember], MovieError>
    func fetchMovieReviews(req: FetchMovieReviewsRequest) -> AnyPublisher<[MovieReview], MovieError>
}

class MovieRepositoryImpl: MovieRepository {
    
    @Inject
    var moya: MoyaProvider<MultiTarget>!
    
    @Inject
    private var store: MediaItemStoreProtocol
    
    @Inject
    private var detailStore: MediaItemDetailStoreProtocol
    
    @Inject
    private var castMemberStore: CastMemberStoreProtocol
    
    @Inject
    private var networkMonitor: NetworkMonitorProtocol
    
    func fetchGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchGenres(req: req)),
            decodeTo: GenreListResponse.self,
            transform: { $0.genres.map(Genre.init(dto:)) }
        )
    }
    
    func fetchTVGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchTVGenres(req: req)),
            decodeTo: GenreListResponse.self,
            transform: { $0.genres.map(Genre.init(dto:)) }
        )
    }
    
    func searchMovies(req: SearchMovieRequest) -> AnyPublisher<[MediaItem], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.searchMovies(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { $0.results.map(MediaItem.init(dto:)) }
        )
    }
    
    func fetchMovies(req: FetchMediaListRequest) -> AnyPublisher<MediaItemPage, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchMovies(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { MediaItemPage(dto: $0) }
        )
    }
    
    func fetchTV(req: FetchMediaListRequest) -> AnyPublisher<MediaItemPage, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchTV(req: req)),
            decodeTo: TVPageResponse.self,
            transform: { MediaItemPage(dto: $0) }
        )
    }
    
    func fetchFavoriteMovies(req: FetchFavoriteMovieRequest, fromLocal: Bool) -> AnyPublisher<[MediaItem], MovieError> {
        
        let serviceResponse: AnyPublisher<[MediaItem], MovieError> = self.requestAndTransform(
            target: MultiTarget(MoviesApi.fetchFavoriteMovies(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { $0.results.map(MediaItem.init(dto:)) }
        )
            .handleEvents(receiveOutput: { [weak self]mediaItems in
                self?.store.saveMediaItems(mediaItems)
            })
            .eraseToAnyPublisher()
        
        let localResponse: AnyPublisher<[MediaItem], MovieError> = store.mediaItems
        
        return networkMonitor.isConnected
            .flatMap { isConnected -> AnyPublisher<[MediaItem], MovieError> in
                if isConnected {
                    return serviceResponse
                } else {
                    return localResponse
                }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchMovieDetail(req: FetchDetailRequest) -> AnyPublisher<MediaItemDetail, MovieError> {
        
        let serviceResponse: AnyPublisher<MediaItemDetail, MovieError> = self.requestAndTransform(
            target: MultiTarget(MoviesApi.fetchMovieDetail(req: req)),
            decodeTo: MovieDetailResponse.self,
            transform: { MediaItemDetail.init(dto: $0) }
        )
            .handleEvents(receiveOutput: { [weak self]mediaItemDetail in
                self?.detailStore.saveMediaItemDetail(mediaItemDetail)
            })
            .eraseToAnyPublisher()
        
        let localResponse: AnyPublisher<MediaItemDetail, MovieError> = detailStore.getMediaItemDetail(withId: req.mediaId)
        
        return networkMonitor.isConnected
            .flatMap { isConnected -> AnyPublisher<MediaItemDetail, MovieError> in
                if isConnected {
                    return serviceResponse
                } else {
                    return localResponse
                }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchMovieCredits(req: FetchMovieCreditsRequest) -> AnyPublisher<[CastMember], MovieError> {
        
        return networkMonitor.isConnected
            .flatMap { isConnected -> AnyPublisher<[CastMember], MovieError> in
                if isConnected {
                    return self.requestAndTransform(
                        target: MultiTarget(MoviesApi.fetchMovieCredits(req: req)),
                        decodeTo: MovieCreditsResponse.self,
                        transform: { dto in
                            dto.cast.map(CastMember.init(dto:))
                        }
                    )
                    .handleEvents(receiveOutput: { [weak self]castMembers in
                        self?.castMemberStore.saveCastMembers(castMembers, forMovieId: req.mediaId)
                    })
                    .eraseToAnyPublisher()
                } else {
                    return self.castMemberStore.getCastMembers(fromMovieId: req.mediaId)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchMovieReviews(req: FetchMovieReviewsRequest) -> AnyPublisher<[MovieReview], MovieError> {
        return networkMonitor.isConnected
            .flatMap { isConnected -> AnyPublisher<[MovieReview], MovieError> in
                if isConnected {
                    return self.requestAndTransform(
                        target: MultiTarget(MoviesApi.fetchMovieReviews(req: req)),
                        decodeTo: MovieReviewsResponse.self,
                        transform: { dto in
                            dto.results.map(MovieReview.init(dto:))
                        }
                    )
                    .handleEvents(receiveOutput: { [weak self]reviews in
                        // TODO: Save reviews to store
                    })
                    .eraseToAnyPublisher()
                } else {
                    // TODO: Fetch reviews from store
                    return Fail(error: MovieError.unexpectedError).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    func editFavoriteMovie(req: EditFavoriteRequest) -> AnyPublisher<EditFavoriteResult, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.editFavoriteMovie(req: req)),
            decodeTo: EditFavoriteResponse.self,
            transform: { response in
                EditFavoriteResult(dto: response)
            }
        )
    }
    
    private func requestAndTransform<ResponseType: Decodable, Output>(
        target: MultiTarget,
        decodeTo: ResponseType.Type,
        transform: @escaping (ResponseType) -> Output
    ) -> AnyPublisher<Output, MovieError> {
        let future = Future<Output, MovieError> { future in
            self.moya.request(target) { result in
                switch result {
                case .success(let response):
                    switch response.statusCode {
                    case 200..<300:
                        do {
                            let decoded = try JSONDecoder().decode(decodeTo, from: response.data)
                            let output = transform(decoded)
                            future(.success(output))
                        } catch {
                            future(.failure(MovieError.mappingError(message: error.localizedDescription)))
                        }
                    case 400..<500:
                        future(.failure(MovieError.clientError))
                    default:
                        if let apiError = try? JSONDecoder().decode(MovieAPIErrorResponse.self, from: response.data) {
                            if apiError.statusCode == 7 {
                                future(.failure(MovieError.invalidApiKeyError(message: apiError.statusMessage)))
                            } else {
                                future(.failure(MovieError.unexpectedError))
                            }
                        } else {
                            future(.failure(MovieError.unexpectedError))
                        }
                    }
                case .failure(let error):
                    if error.isNoInternetError {
                        future(.failure(MovieError.noInternetError))
                    } else {
                        future(.failure(MovieError.unexpectedError))
                    }
                    
                }
            }
        }
        return future
            .eraseToAnyPublisher()
            
    }
    
    func fetchFavoriteMovies2(req: FetchFavoriteMovieRequest, fromLocal: Bool = false) -> AnyPublisher<[MediaItem], MovieError> {
            networkMonitor.isConnected
                .flatMap { [weak self]isConnected in
                    guard let self = self else {
                        preconditionFailure("There is no self")
                    }
                    if !isConnected || fromLocal {
                        return self.store.mediaItems
                    }
                    return self.requestAndTransform(
                        target: MultiTarget(MoviesApi.fetchFavoriteMovies(req: req)),
                        decodeTo: MoviePageResponse.self,
                        transform: { $0.results.map(MediaItem.init(dto:)) }
                    )
                    
                }
                .handleEvents(receiveOutput: { [weak self]mediaItems in
                    guard let self = self else {
                        preconditionFailure("There is no self")
                    }
                    self.store.saveMediaItems(mediaItems)
                })
                .eraseToAnyPublisher()
        }
}

extension MoyaError {
    var isNoInternetError: Bool {
        if case let .underlying(error, _) = self {
            // Ha AFError
            if let afError = error as? AFError {
                if let urlError = afError.underlyingError as? URLError {
                    return urlError.code == .notConnectedToInternet
                } else if let nsError = afError.underlyingError as NSError? {
                    return nsError.domain == NSURLErrorDomain && nsError.code == NSURLErrorNotConnectedToInternet
                }
            }
        }
        return false
    }
}

