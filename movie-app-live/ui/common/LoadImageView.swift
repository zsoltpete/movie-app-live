//
//  LoadImageView.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 05. 16..
//

import SwiftUI
import SDWebImageSwiftUI

struct LoadImageView: View {
    let url: URL?

    var body: some View {
        if let url = url {
            WebImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ZStack {
                    Color.gray.opacity(0.3)
                    ProgressView()
                }
            }
        } else {
            ZStack {
                Color.gray.opacity(0.3)
                Image(systemName: "photo")
            }
            
        }
        
    }
}

