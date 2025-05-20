//
//  MediaItemHeaderView.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 05. 20..
//

import SwiftUI

struct MediaItemHeaderView: View {
    
    let title: String
    let year: String
    let runtime: String
    let spokenLanguages: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: LayoutConst.largePadding) {
            Text(title)
                .font(Fonts.detailsTitle)
            
            HStack(spacing: LayoutConst.normalPadding) {
                DetailLabel(title: "detail.releaseDate", desc: year)
                DetailLabel(title: "detail.runtime", desc: "\(runtime)")
                DetailLabel(title: "detail.language", desc: spokenLanguages)
            }
        }
    }
}
