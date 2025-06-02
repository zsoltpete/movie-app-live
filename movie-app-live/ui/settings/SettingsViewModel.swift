import Foundation
import SwiftUI

protocol SettingsViewModelProtocol: ObservableObject {
    // TODO: Add settings related properties and methods
}

class SettingsViewModel: SettingsViewModelProtocol {
    @Published var selectedLanguage: String = Bundle.getLangCode()
    @Published var selectedTheme: Theme = .light {
        didSet {
            UserDefaults.standard.set(selectedTheme.rawValue, forKey: "color-scheme")
        }
    }
    
    
    init() {
        let storedThem = UserDefaults.standard.string(forKey: "color-scheme")
        self.selectedTheme = Theme(rawValue: storedThem ?? "") ?? .light
    }
    
    func changeSelectedLanguge(_ language: String) {
        self.selectedLanguage = language
        Bundle.setLanguage(lang: language)
    }
    
    func changeTheme(_ theme: Theme) {
        self.selectedTheme = theme
    }
    
}

extension ColorScheme {
    var rawValue: String {
        self == .light ? "light" : "dark"
    }
    
    init(_ rawValue: String) {
        self = rawValue == "light" ? .light : .dark
    }
}
