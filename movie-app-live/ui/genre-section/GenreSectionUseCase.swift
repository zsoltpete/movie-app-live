//
//  GenreSectionUseCase.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 05. 27..
//

import InjectPropertyWrapper
import Combine
import Foundation

protocol GenreSectionUseCase {
    var showAppearPopup: AnyPublisher<Bool, Never> { get }
    func loadGenres() -> AnyPublisher<[Genre], MovieError>
    func genresAppeared()
    func loadMovies(for genre: Genre) -> AnyPublisher<[MediaItem], MovieError>
}

class GenreSectionUseCaseImpl: GenreSectionUseCase {
    
    @Inject
    private var repository: MovieRepository
    
    private var appearCounter = 0
    
    private var appearSubject = CurrentValueSubject<Int, Never>(0)
    
    var showAppearPopup: AnyPublisher<Bool, Never> {
        appearSubject.map { counter in
            counter == 3
        }
        .eraseToAnyPublisher()
    }
    
    func loadGenres() -> AnyPublisher<[Genre], MovieError> {
        let request = FetchGenreRequest()
        
        let genres = Environments.name == .tv ?
        self.repository.fetchTVGenres(req: request) :
        self.repository.fetchGenres(req: request)
        
        return genres
            .handleEvents(receiveOutput: { genres in
                print("Custom action before receive: genres count = \(genres.count)")
            })
            .eraseToAnyPublisher()
    }
    
    func genresAppeared() {
        appearCounter += 1
        appearSubject.send(appearCounter)
    }
    
    func loadMovies(for genre: Genre) -> AnyPublisher<[MediaItem], MovieError> {
        let request = FetchMediaListRequest(genreId: genre.id, includeAdult: true)
        return self.repository.fetchMovies(req: request)
            .delay(for: .seconds(2), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
                                        
    }
    
}
