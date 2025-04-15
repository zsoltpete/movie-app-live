//
//  movie_app_liveApp.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 04. 08..
//

import SwiftUI

@main
struct movie_app_liveApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            GenreSectionView()
        }
    }
}
