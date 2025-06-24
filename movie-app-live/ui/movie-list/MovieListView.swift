//
//  MovieListView.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 04. 15..
//

import SwiftUI
import InjectPropertyWrapper

struct MovieListView: View {
    @StateObject private var viewModel = MovieListViewModel()
    let genre: Genre
    
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: LayoutConst.largePadding) {
                ForEach(viewModel.movies.indices, id: \.self) { index in
                    let mediaItem = viewModel.movies[index]
                    NavigationLink(destination: DetailView(mediaItem: mediaItem)) {
                        MediaItemCell(movie: mediaItem)
                            .onAppear {
                                if index == viewModel.movies.count - 1 {
                                    viewModel.reachedBottomSubject.send()
                                }
                            }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, LayoutConst.normalPadding)
            .padding(.top, LayoutConst.normalPadding)
            
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            }
        }
        .navigationTitle(genre.name)
        .showAlert(model: $viewModel.alertModel)
        .onAppear {
            viewModel.genreIdSubject.send(genre.id)
        }
    }
}

#Preview {
    MovieListView(genre: Genre(id: 28, name: "Action") )
}
