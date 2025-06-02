//
//  CustomLottieView.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 05. 30..
//

import Lottie
import SwiftUI

struct CustomLottieView: View {
    let name: String
    let completion: () -> Void
    
    var body: some View {
        /*
        LottieView {
                    try await loadAnimation()
                } placeholder: {
                    ProgressView()
                }
        */
        
        LottieView {
            let fileURL = Bundle.main.url(forResource: "movies", withExtension: "json")!
            return await LottieAnimation
              .loadedFrom(url: fileURL)
        } placeholder: {
            ProgressView()
        }
        
        .playing(loopMode: .playOnce)
        .animationDidLoad({ _ in
        })
        .animationDidFinish({ completed in
            completion()
        })
        .frame(width: 200, height: 200)
    }

    private func loadAnimation() async throws -> LottieAnimationSource? {
        let dotLottie = try await DotLottieFile.named(name)
        return dotLottie.animationSource
    }
}
