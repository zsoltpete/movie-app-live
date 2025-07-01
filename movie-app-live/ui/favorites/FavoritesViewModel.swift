import Foundation
import Combine
import InjectPropertyWrapper

protocol FavoritesViewModelProtocol: ObservableObject {
    var mediaItems: [MediaItem] { get }
}

class FavoritesViewModel: FavoritesViewModelProtocol, ErrorPresentable {
    @Published var mediaItems: [MediaItem] = []
    @Published var alertModel: AlertModel? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    let viewLoaded = PassthroughSubject<Void, Never>()
    
    @Inject
    private var repository: MovieRepository
    
    init() {
        
        viewLoaded
            .flatMap { [weak self]_ -> AnyPublisher<[MediaItem], MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                return Environments.name == .tv ?
                self.repository.fetchFavoriteTVs(req: FetchFavoriteMediaItemRequest(),
                                                                                   fromLocal: false) : self.repository.fetchFavoriteMovies(req: FetchFavoriteMediaItemRequest(),
                                                                                   fromLocal: false)
            }
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.alertModel = self.toAlertModel(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self]mediaItems in
                self?.mediaItems = mediaItems
            }
            .store(in: &cancellables)
    }
}
