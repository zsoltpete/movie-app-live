//
//  MediaItemListView.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 04. 15..
//

import SwiftUI
import InjectPropertyWrapper

struct MediaItemListView: View {
    @StateObject private var viewModel = MediaItemListViewModel()
    let genre: Genre
    
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: LayoutConst.largePadding) {
                ForEach(viewModel.mediaItems.indices, id: \.self) { index in
                    let mediaItem = viewModel.mediaItems[index]
                    NavigationLink(destination: DetailView(mediaItem: mediaItem)) {
                        MediaItemCell(movie: mediaItem)
                            .onAppear {
                                if index == viewModel.mediaItems.count - 1 {
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
    MediaItemListView(genre: Genre(id: 28, name: "Action") )
}
