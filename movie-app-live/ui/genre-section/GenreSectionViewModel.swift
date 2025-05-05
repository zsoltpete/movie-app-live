import Foundation
import InjectPropertyWrapper
import Combine

protocol ErrorViewModelProtocol {
    var alertModel: AlertModel? { get }
}

protocol GenreSectionViewModelProtocol: ObservableObject {
    var genres: [Genre] { get }
}

class GenreSectionViewModel: GenreSectionViewModelProtocol, ErrorViewModelProtocol {
    @Published var genres: [Genre] = []
    @Published var alertModel: AlertModel? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    @Inject
    private var movieService: MoviesServiceProtocol
    
    @Inject
    private var reactiveMovieService: ReactiveMoviesServiceProtocol
    
//    func fetchGenres() async {
//        do {
//            let request = FetchGenreRequest()
//            let genres = Environments.name == .tv ? try await movieService.fetchTVGenres(req: request) :
//                                                    try await movieService.fetchGenres(req: request)
//            DispatchQueue.main.async {
//                self.genres = genres
//            }
//        } catch {
//            DispatchQueue.main.async {
//                self.alertModel = self.toAlerModel(error)
//            }
//        }
//    }
    
    private func toAlerModel(_ error: Error) -> AlertModel {
        guard let error = error as? MovieError else {
            return AlertModel(
                title: "unexpected.error.title",
                message: "unexpected.error.message",
                dismissButtonTitle: "button.close.text"
            )
        }
        switch error {
        case .invalidApiKeyError(let message):
            return AlertModel(
                title: "API Error",
                message: message,
                dismissButtonTitle: "button.close.text"
            )
        case .clientError:
            return AlertModel(
                title: "Client Error",
                message: error.localizedDescription,
                dismissButtonTitle: "button.close.text"
            )
        default:
            return AlertModel(
                title: "unexpected.error.title",
                message: "unexpected.error.message",
                dismissButtonTitle: "button.close.text"
            )
        }
    }
    
    init() {
        let request = FetchGenreRequest()
        
        let future = Future<[Genre], Error> { future in
            Task {
                do {
                    let genres = try await self.movieService.fetchGenres(req: request)
                    future(.success(genres))
                } catch {
                    future(.failure(error))
                }
            }
        }
        
        let futureTV = Future<[Genre], Error> { future in
            Task {
                do {
                    let genres = try await self.movieService.fetchTVGenres(req: request)
                    future(.success(genres))
                } catch {
                    future(.failure(error))
                }
            }
        }
        
        Publishers.CombineLatest(future, futureTV)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.alertModel = self.toAlerModel(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self]genres, genresTV in
                self?.genres = genres + genresTV
            }
            .store(in: &cancellables)
    }
    
//    init() {
//        let request = FetchGenreRequest()
//        
//        let publisher = PassthroughSubject<[Genre], Error>()
//
//        Task {
//            do {
//                let genres = try await self.movieService.fetchTVGenres(req: request)
//                publisher.send(genres)
//                publisher.send(completion: .finished) // FONTOS: befejezés
//            } catch {
//                publisher.send(completion: .failure(error)) // Hiba küldése
//            }
//        }
//        
//        publisher
//            .receive(on: RunLoop.main)
//            .sink { completion in
//                switch completion {
//                case .failure(let error):
//                    self.alertModel = self.toAlerModel(error)
//                case .finished:
//                    break
//                }
//            } receiveValue: { genres in
//                self.genres = genres
//            }
//            .store(in: &cancellables)
//    }
    
//    init() {
//        let request = FetchGenreRequest()
//        
//        let genresFuture = self.reactiveMovieService.fetchGenres(req: request)
//        
//        let genresTVFuture = self.reactiveMovieService.fetchTVGenres(req: request)
//        
//        //        Publishers.CombineLatest(genresFuture, genresTVFuture)
//        genresFuture.flatMap({ genresFuture in
//            genresTVFuture.map { genresTVFuture in
//                (genresFuture, genresTVFuture)
//            }
//        })
//        .handleEvents(receiveOutput: { (genres, genresTV) in
//            print("Custom action before receive: genres count = \(genres.count), TV genres count = \(genresTV.count)")
//        })
//        .print("<<<debug")
//        .sink { completion in
//            if case let .failure(error) = completion {
//                self.alertModel = self.toAlerModel(error)
//            }
//        } receiveValue: { genres1, genres2 in
//            self.genres = genres1 + genres2
//        }
//        .store(in: &cancellables)
//    }
}
