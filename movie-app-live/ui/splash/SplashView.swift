//
//  SplashView.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 05. 30..
//

import Lottie
import SwiftUI

struct SplashView: View {
    
    @State private var showRootView = true
    @State var selectedTab: TabType = TabType.genre
    
    var body: some View {
        if showRootView {
            RootView(selectedTab: selectedTab)
        } else {
            CustomLottieView(name: "movies.lottie", completion: {
                showRootView = true
            })
        }
    }
}
