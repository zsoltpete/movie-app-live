import Foundation
import Combine
import InjectPropertyWrapper

protocol FavoritesViewModelProtocol: ObservableObject {
    var movies: [MediaItem] { get }
}

class FavoritesViewModel: FavoritesViewModelProtocol, ErrorPrentable {
    @Published var movies: [MediaItem] = []
    @Published var alertModel: AlertModel? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    @Inject
    private var service: ReactiveMoviesServiceProtocol
    
    init() {
        let request = FetchFavoriteMovieRequest()
        
        service.fetchFavoriteMovies(req: request)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.alertModel = self.toAlerModel(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self]movies in
                self?.movies = movies
            }
            .store(in: &cancellables)
    }
}
