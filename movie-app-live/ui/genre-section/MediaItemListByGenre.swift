//
//  MediaItemListByGenre.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 05. 31..
//

import SwiftUI


struct MediaItemListByGenre: View {
    
    let genre: Genre
    let mediaItems: [MediaItem]
    
    var body: some View {
        VStack{
            GenreSectionCell(genre: genre, movies: mediaItems)
            ScrollView(.horizontal){
                HStack(spacing: 20) {
                    ForEach(mediaItems) {mediaItem in
                        NavigationLink(destination: DetailView(mediaItem: mediaItem)) {
                                                    MediaItemCell(movie: mediaItem)
                                .frame(width: 200)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .listRowBackground(Color.clear)
        }
        
    }
}
