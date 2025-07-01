//
//  LanguageManager.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 05. 27..
//

import Foundation

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    private init() {}
    
    @Published var currentLanguage: String = Bundle.getLangCode()

    func setLanguage(_ lang: String) {
        guard lang != currentLanguage else { return }
        Bundle.setLanguage(lang: lang)
        UserDefaults.standard.set(lang, forKey: "app_lang")
        currentLanguage = lang
    }
}
