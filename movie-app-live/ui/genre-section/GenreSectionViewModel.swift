import Foundation
import InjectPropertyWrapper

protocol GenreSectionViewModelProtocol: ObservableObject {
    var genres: [Genre] { get }
    func fetchGenres() async
}

class GenreSectionViewModel: GenreSectionViewModelProtocol {
    @Published var genres: [Genre] = []
    
    @Inject
    private var movieService: MoviesServiceProtocol
    
    func fetchGenres() async {
        do {
            let request = FetchGenreRequest()
            let genres = Environments.name == .tv ? try await movieService.fetchTVGenres(req: request) :
                                                    try await movieService.fetchGenres(req: request)
            DispatchQueue.main.async {
                self.genres = genres
            }
        } catch {
            print("Error fetching genres: \(error)")
        }
    }
} 