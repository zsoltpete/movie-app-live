import Foundation
import InjectPropertyWrapper
import Combine

protocol MovieListViewModelProtocol: ObservableObject {
    var movies: [MediaItem] { get }
}

class MovieListViewModel: MovieListViewModelProtocol, ErrorPrentable {
    @Published var movies: [MediaItem] = []
    @Published var alertModel: AlertModel? = nil
    
    let genreIdSubject = PassthroughSubject<Int, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    @Inject
    private var service: ReactiveMoviesServiceProtocol
    
    init() {
        
        genreIdSubject
            .flatMap { [weak self] genreId -> AnyPublisher<[MediaItem], MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchMediaListRequest(genreId: genreId)
                return Environments.name == .tv ?
                                                self.service.fetchTV(req: request) :
                                                self.service.fetchMovies(req: request)
                
            }
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlerModel(error)
                }
            } receiveValue: { [weak self] movies in
                self?.movies = movies
            }
            .store(in: &cancellables)
    }
}
