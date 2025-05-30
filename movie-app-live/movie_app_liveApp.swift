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
    
    @State var selectedTab: TabType = TabType.genre
    
    @AppStorage("color-scheme") var colorSchemeRawValue: String = "light"
    
    var colorScheme: ColorScheme {
        if colorSchemeRawValue == "light" {
            return .light
        } else {
            return .dark
        }
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(selectedTab: selectedTab)
                .preferredColorScheme(colorScheme)
        }
    }
    
    
}
