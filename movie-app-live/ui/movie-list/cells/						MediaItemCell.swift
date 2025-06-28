//
//  MovieCell.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 04. 26..
//

import Shimmer
import SwiftUI

struct MediaItemCell: View {
    let movie: MediaItem
    
    var body: some View {
        if movie.id < 0 {
            VStack {
                Color.gray
            }
            .frame(height: 100)
            .frame(maxHeight: 180)
            .cornerRadius(12)
            .shimmering()
            .allowsHitTesting(false)
        } else {
            VStack(alignment: .leading, spacing: LayoutConst.smallPadding) {
                ZStack(alignment: .topLeading) {
                    HStack(alignment: .center) {
                        LoadImageView(url: movie.imageUrl)
                        .frame(height: 100)
                        .frame(maxHeight: 180)
                        .cornerRadius(12)
                    }
                    
                    HStack(spacing: 12.0) {
                        MediaItemLabel(type: .rating(movie.rating))
                        MediaItemLabel(type: .voteCount(movie.voteCount))
                    }
                    .padding(LayoutConst.smallPadding)
                    
                }

                HStack {
                    VStack(alignment: .leading) {
                        Text(movie.title)
                            .font(Fonts.subheading)
                            .lineLimit(2)
                            .truncationMode(.tail)
                            .frame(maxWidth: 150, alignment: .leading)
                        
                        Text("\(movie.year)")
                            .font(Fonts.paragraph)
                        
                        Text("\(movie.duration)")
                            .font(Fonts.caption)
                    }
                    
                    Spacer()
                    
                    Image(.playButton)
                }
            }
            .contentShape(Rectangle())
        }
        
    }
}

#Preview {
    MediaItemCell(movie: MediaItem(id: 2,
                                   title: "Mock movie2",
                                   year: "2024",
                                   duration: "1h 34m",
                                   imageUrl: nil,
                                   rating: 1.0,
                                   voteCount: 1000
                                  )
    )
}
