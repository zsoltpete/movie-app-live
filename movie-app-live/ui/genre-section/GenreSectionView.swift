//
//  GenreSectionView.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 04. 08..
//

import SwiftUI
import InjectPropertyWrapper

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

                    GenreSectionCell(genre: genre)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .navigationTitle(Environments.name == .tv ? "TV" : "genreSection.title")
            .accessibilityLabel("testCollectionView")
        }
        .onAppear {
            Task {
                await viewModel.fetchGenres()
            }
        }
        .alert(item: $viewModel.alertModel) { model in
            return Alert(
                title: Text(LocalizedStringKey(model.title)),
                message: Text(LocalizedStringKey(model.message)),
                dismissButton: .default(Text(LocalizedStringKey(model.dismissButtonTitle))) {
                    viewModel.alertModel = nil
                }
            )
        }
    }
}

#Preview {
    GenreSectionView()
}
