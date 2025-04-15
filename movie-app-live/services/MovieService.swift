//
//  MovieService.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 04. 12..
//

import Foundation
import Moya

protocol MoviesServiceProtocol {
    func fetchGenres(req: FetchGenreRequest) async throws -> [Genre]
    func fetchMovies(req: FetchMoviesRequest) async throws -> [Movie]
}

class MoviesService: MoviesServiceProtocol {
    
    var moya: MoyaProvider<MultiTarget>!
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        
        self.moya = MoyaProvider<MultiTarget>(
            session: Session(configuration: configuration,
                             startRequestsImmediately: false),
            plugins: [
                NetworkLoggerPlugin()
            ])
    }
    
    func fetchGenres(req: FetchGenreRequest) async throws -> [Genre] {
        return try await withCheckedThrowingContinuation { continuation in
            moya.request(MultiTarget(MoviesApi.fetchGenres(req: req))) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedResponse = try JSONDecoder().decode(GenreListResponse.self, from: response.data)
                        
                        let genres = decodedResponse.genres.map { genreResponse in
                            Genre(dto: genreResponse)
                        }
                        
                        continuation.resume(returning: genres)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func fetchMovies(req: FetchMoviesRequest) async throws -> [Movie] {
        return try await withCheckedThrowingContinuation { continuation in
            moya.request(MultiTarget(MoviesApi.fetchMovies(req: req))) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedResponse = try JSONDecoder().decode(MoviePageResponse.self, from: response.data)
                        let movies = decodedResponse.results.map { Movie(dto: $0) }
                        continuation.resume(returning: movies)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    
}
