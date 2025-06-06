import Foundation
import InjectPropertyWrapper
import Combine

protocol GenreSectionViewModel: ObservableObject {
    var genres: [Genre] { get }
    func loadGenres()
    func genresAppeared()
}

class GenreSectionViewModelImpl: GenreSectionViewModel, ErrorPresentable {
    @Published var genres: [Genre] = []
    @Published var motdMovie: MediaItemDetail?
    @Published var alertModel: AlertModel? = nil
    @Published var movies: [Int: [MediaItem]] = [:]
    
    let placeholdertMovies: [MediaItem] = [MediaItem(id: -1), MediaItem(id: -2), MediaItem(id: -3)]
    
    private var cancellables = Set<AnyCancellable>()
    
    @Inject
    private var useCase: GenreSectionUseCase
    
    @Inject
    private var mediaItemRepository: MediaItemStoreProtocol
    
    init() {
        useCase.showAppearPopup
            .compactMap { showAppearPopup -> AlertModel? in
                if showAppearPopup {
                    return AlertModel(title: "[[Értékeld az appot]]", message: "[[Értékeld az appot]]", dismissButtonTitle: "[[Rendber]]")
                }
                return nil
            }
            .sink { [weak self]alertModel in
                self?.alertModel = alertModel
            }
            .store(in: &cancellables)
    }
    
    func loadGenres() {
        useCase.loadGenres()
            .sink { completion in
                if case let .failure(error) = completion {
                    self.alertModel = self.toAlertModel(error)
                }
            } receiveValue: { genres in
                self.genres = genres
            }
            .store(in: &cancellables)
    }
    
    func genresAppeared() {
        useCase.genresAppeared()
    }
    
    func loadMovies(for genre: Genre) {
        
        movies[genre.id] = placeholdertMovies
        
        useCase
            .loadMovies(for: genre)
            .map({ items in
                Array(items.prefix(3))
            })
            .sink { completion in
                if case let .failure(error) = completion {
                    self.alertModel = self.toAlertModel(error)
                }
            } receiveValue: { [weak self] fetchedMovies in
                guard let self = self else {
                    return
                }
                self.movies[genre.id] = fetchedMovies
                
                if self.motdMovie == nil, let randomMovie = fetchedMovies.randomElement() {
                    self.loadMotdMovie(movie: randomMovie)
                }
            }
            .store(in: &cancellables)
        
    }
    
    func loadMotdMovie(movie: MediaItem) {
            useCase.loadMotdMovie(movie: movie)
                .sink { completion in
                    if case let .failure(error) = completion {
                        self.alertModel = self.toAlertModel(error)
                    }
                } receiveValue: { movie in
                    self.motdMovie = movie
                }
                .store(in: &cancellables)
        }
}
