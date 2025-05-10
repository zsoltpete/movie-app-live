//
//  DetailView.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 05. 09..
//

import SwiftUI

struct DetailView: View {
    @StateObject private var viewModel = DetailViewModel()
    let mediaItem: MediaItem
    
    var body: some View {
        
        var mediaItemDetail: MediaItemDetail {
            viewModel.mediaItemDetail
        }
        
        return ScrollView {
            VStack(alignment: .leading, spacing: LayoutConst.largePadding) {
                AsyncImage(url: mediaItemDetail.imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Color.gray.opacity(0.3)
                            ProgressView()
                        }

                    case let .success(image):
                        image
                            .resizable()
                            .scaledToFill()

                    case .failure(let error):
                        ZStack {
                            Color.red.opacity(0.3)
                            Image(systemName: "photo")
                                .foregroundColor(.white)
                        }
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: 180)
                .frame(maxWidth: .infinity)
                .cornerRadius(30)
                
                HStack(spacing: 12.0) {
                    MovieLabel(type: .rating(mediaItemDetail.rating))
                    MovieLabel(type: .voteCount(mediaItemDetail.voteCount))
                    MovieLabel(type: .popularity(mediaItemDetail.popularity))
                    Spacer()
                    MovieLabel(type: .adult(mediaItemDetail.adult))
                }
                
                Text(viewModel.mediaItemDetail.genreList)
                    .font(Fonts.paragraph)
                Text(viewModel.mediaItemDetail.title)
                    .font(Fonts.detailsTitle)
                
                HStack(spacing: LayoutConst.normalPadding) {
                    DetailLabel(title: "detail.releaseDate", desc: mediaItemDetail.year)
                    DetailLabel(title: "detail.runtime", desc: "\(mediaItemDetail.runtime)")
                    DetailLabel(title: "detail.language", desc: mediaItemDetail.spokenLanguages)
                }
                
                HStack {
                    StyledButton(style: .outlined, title: "detail.rate.button")
                    Spacer()
                    StyledButton(style: .filled, title: "detail.imdb.button")
                }
                
                VStack(alignment: .leading, spacing: 12.0) {
                    Text(LocalizedStringKey("detail.overview"))
                        .font(Fonts.overviewText)
                    
                    Text(mediaItemDetail.overview)
                        .font(Fonts.paragraph)
                        .lineLimit(nil)
                }

            }
            .padding(.horizontal, LayoutConst.maxPadding)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    
                }) {
                    Image(.favorite)
                        .resizable()
                        .frame(height: 30.0)
                        .frame(width: 30.0)
                }
            }
        }
        .showAlert(model: $viewModel.alertModel)
        .onAppear {
            viewModel.mediaItemIdSubject.send(mediaItem.id)
        }
    }
}

struct DetailView2: View {
    @StateObject private var viewModel = DetailViewModel2()
    let mediaItem: MediaItem
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                if let posterPath = viewModel.mediaItem.imageUrl {
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 185)
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                    } placeholder: {
                        ProgressView()
                            .frame(height: 185)
                    }
                }
                
                HStack {
                    MovieLabel(type: .rating(viewModel.mediaItem.rating))
                    MovieLabel(type: .voteCount(viewModel.mediaItem.voteCount))
                    MovieLabel(type: .popularity(viewModel.mediaItem.popularity))
                }
                
                HStack {
                    StyledButton(style: .outlined, title: "detail.rate.button") {
                        
                    }
                    Spacer()
                    StyledButton(style: .filled, title: "detail.imdb.button") {
                        
                    }
                }
            }
            .padding()
        }
        .navigationTitle(viewModel.mediaItem.title)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    viewModel.favoriteButtonTapped.send(())
                }) {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.isFavorite ? .red : .gray)
                }
            }
        }
        .onAppear {
            viewModel.mediaItemIdSubject.send(mediaItem.id)
        }
    }
}
