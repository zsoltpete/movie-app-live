import Foundation
import InjectPropertyWrapper
import Combine

protocol MediaItemListViewModelProtocol: ObservableObject {
    var mediaItems: [MediaItem] { get }
}

class MediaItemListViewModel: MediaItemListViewModelProtocol, ErrorPresentable {
    @Published var mediaItems: [MediaItem] = []
    @Published var alertModel: AlertModel? = nil
    @Published var isLoading: Bool = false
    
    let genreIdSubject = PassthroughSubject<Int, Never>()
    let reachedBottomSubject = CurrentValueSubject<Void, Never>(())
    
    private var cancellables = Set<AnyCancellable>()
    
    private var currentPage: Int = 1
    private var totalPages: Int = Int.max
    
    @Inject
    private var repository: MovieRepository
    
    init() {
        
        Publishers.CombineLatest(reachedBottomSubject, genreIdSubject)
            .filter { [weak self]_ in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                return self.currentPage < self.totalPages
            }
            .handleEvents(receiveOutput: { [weak self]_ in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                self.isLoading = true
            })
            .flatMap { [weak self] _, genreId -> AnyPublisher<MediaItemPage, MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchMediaListRequest(genreId: genreId, includeAdult: true, page: self.currentPage)
                return Environments.name == .tv ?
                        self.repository.fetchTV(req: request) :
                        self.repository.fetchMovies(req: request)
                
            }
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                    self?.isLoading = false
                }
            } receiveValue: { [weak self] page in
                guard let self else { return }
                self.mediaItems.append(contentsOf: page.mediaItems)
                self.currentPage += 1
                self.totalPages = page.totalPages
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
}
