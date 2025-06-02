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
    
    @AppStorage("color-scheme") var colorScheme: Theme = .light
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                .preferredColorScheme(ColorScheme(theme: colorScheme))
        }
        
    }
    
    
}
