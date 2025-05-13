import Foundation
import InjectPropertyWrapper
import Combine

protocol GenreSectionViewModelProtocol: ObservableObject {
    var genres: [Genre] { get }
}

class GenreSectionViewModel: GenreSectionViewModelProtocol, ErrorPresentable {
    @Published var genres: [Genre] = []
    @Published var alertModel: AlertModel? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    @Inject
    private var service: ReactiveMoviesServiceProtocol
    
    @Inject
    private var favoriteMediaStore: FavoriteMediaStoreProtocol
    
    init() {
        let request = FetchGenreRequest()
        
        let genres = Environments.name == .tv ?
        self.service.fetchTVGenres(req: request) :
        self.service.fetchGenres(req: request)
        
        genres
            .handleEvents(receiveOutput: { genres in
                print("Custom action before receive: genres count = \(genres.count)")
            })
            .sink { completion in
                if case let .failure(error) = completion {
                    self.alertModel = self.toAlertModel(error)
                }
            } receiveValue: { genres in
                self.genres = genres
            }
            .store(in: &cancellables)
        
        let favoriteRequest = FetchFavoriteMovieRequest()
        
        service.fetchFavoriteMovies(req: favoriteRequest)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.alertModel = self.toAlertModel(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self]movies in
                self?.favoriteMediaStore.addFavoriteMediaItems(movies)
            }
            .store(in: &cancellables)
    }
}
