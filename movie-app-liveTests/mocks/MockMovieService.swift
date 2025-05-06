import Foundation
@testable import movie_app_live

class MockMovieService: MoviesServiceProtocol {
    var mockGenres: [Genre] = []
    var mockMovies: [MediaItem] = []
    
    func fetchGenres(req: FetchGenreRequest) async throws -> [Genre] {
        return mockGenres
    }
    
    func fetchTVGenres(req: FetchGenreRequest) async throws -> [Genre] {
        return mockGenres
    }
    
    func fetchMovies(req: FetchMediaListRequest) async throws -> [MediaItem] {
        return mockMovies
    }
    
    func searchMovies(req: SearchMovieRequest) async throws -> [MediaItem] {
        return mockMovies
    }
} 
