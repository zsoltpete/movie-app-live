import Foundation
import Combine
import InjectPropertyWrapper

protocol SearchViewModelProtocol: ObservableObject {
    var movies: [Movie] { get }
    var searchText: String { get set }
    func searchMovies() async
}

class SearchViewModel: SearchViewModelProtocol {
    @Published var movies: [Movie] = []
    @Published var searchText: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    @Inject
    private var service: MoviesServiceProtocol
    
    func searchMovies() async {
        guard !searchText.isEmpty else {
            DispatchQueue.main.async {
                self.movies = []
            }
            return
        }
        
        do {
            let request = SearchMovieRequest(query: searchText)
            let movies = try await service.searchMovies(req: request)
            
            DispatchQueue.main.async {
                self.movies = movies
            }
        } catch {
            print("Error searching movies: \(error)")
        }
    }
    
//    @Inject
//    private var reactiveService: ReactiveMoviesServiceProtocol
//    
//    init() {
//        $searchText
//            .debounce(for: .seconds(2.5), scheduler: RunLoop.main)
////            .throttle(for: .seconds(1), scheduler: RunLoop.main, latest: true)
//            .setFailureType(to: MovieError.self)
//            .print("<<<$searchText")
//            .map({ searchText in
//                SearchMovieRequest(query: searchText)
//            })
//            .flatMap({ request -> AnyPublisher<[Movie], MovieError> in
//                self.reactiveService.searchMovies(req: request)
//            })
//            .sink(receiveCompletion: { completion in
//                if case let .failure(error) = completion {
//                    //self.alertModel = self.toAlerModel(error)
//                }
//            }, receiveValue: { movies in
//                print(movies)
//            }
//            )
//            .store(in: &cancellables)
//    }
}
