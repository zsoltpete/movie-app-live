//
//  GenreSectionCell.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 04. 26..
//

import SwiftUI

struct GenreSectionCell: View {
    let genre: Genre
    let movies: [MediaItem]
    var onExpand: (() -> Void)? = nil
    @State private var isExpanded = false

    private let expandedHeight: CGFloat = 200

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(genre.name)
                    .font(Fonts.title)
                    .foregroundStyle(.primary)
                Spacer()
                Image(.rightArrow)
                    .rotationEffect(.degrees(isExpanded ? 90 : 0))
                    //.animation(.easeInOut, value: isExpanded)
                    .onTapGesture {
                        isExpanded.toggle()
                        
                        if isExpanded {
                            onExpand?()
                        }
                    }
            }

            ZStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        ForEach(movies) { movie in
                                                    MediaItemCell(movie: movie)
                                .frame(width: 160)
                        }
                    }
                    .padding(.top, LayoutConst.normalPadding)
                }
                .opacity(isExpanded ? 1 : 0)
            }
            .frame(height: isExpanded ?  expandedHeight : 0.0)
        }
    }
}
