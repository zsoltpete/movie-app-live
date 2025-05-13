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
        
        var credits: [CastMember] {
            viewModel.credits
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
                ParticipantScrollView(title: "detail.publishers", participants: mediaItemDetail.productionCompanies)
                
                ParticipantScrollView(title: "detail.cast", participants: credits)
            }
            .padding(.horizontal, LayoutConst.maxPadding)
            .padding(.bottom, LayoutConst.largePadding)

        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    viewModel.favoriteButtonTapped.send(())
                }) {
                    Image(viewModel.isFavorite ? .favorite : .nonfavorite)
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
