//
//  GenreSectionView.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 04. 08..
//

import SwiftUI
import InjectPropertyWrapper

protocol GenreSectionViewModelProtocol: ObservableObject {
    
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

struct GenreSectionView: View {
    
    @StateObject private var viewModel = GenreSectionViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.genres) { genre in
                ZStack {
                    NavigationLink(destination: MovieListView(genre: genre)) {
                        EmptyView()
                    }
                    .opacity(0)

                    HStack {
                        Text(genre.name)
                            .font(Fonts.title)
                            .foregroundStyle(.primary)
                        Spacer()
                        Image(.rightArrow)
                    }
                    
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .navigationTitle(Environments.name == .tv ? "TV" : "genreSection.title")
            
        }
        .onAppear {
            Task {
                await viewModel.fetchGenres()
            }
            
        }
        
    }
}

#Preview {
    GenreSectionView()
}
