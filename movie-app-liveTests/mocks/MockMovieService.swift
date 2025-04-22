import Foundation
@testable import movie_app_live

class MockMovieService: MoviesServiceProtocol {
    var mockGenres: [Genre] = []
    var mockMovies: [Movie] = []
    
    func fetchGenres(req: FetchGenreRequest) async throws -> [Genre] {
        return mockGenres
    }
    
    func fetchTVGenres(req: FetchGenreRequest) async throws -> [Genre] {
        return mockGenres
    }
    
    func fetchMovies(req: FetchMoviesRequest) async throws -> [Movie] {
        return mockMovies
    }
    
    func searchMovies(req: SearchMovieRequest) async throws -> [Movie] {
        return mockMovies
    }
} 