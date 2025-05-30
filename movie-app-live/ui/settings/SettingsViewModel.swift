import Foundation
import SwiftUI

protocol SettingsViewModelProtocol: ObservableObject {
    // TODO: Add settings related properties and methods
}

class SettingsViewModel: SettingsViewModelProtocol {
    @Published var selectedLanguage: String = Bundle.getLangCode()
    @Published var selectedTheme: ColorScheme = .light
    
    @AppStorage("color-scheme") var colorSchemeRawValue: String = "light"
    
    init() {
        self.selectedTheme = ColorScheme(colorSchemeRawValue)
    }
    
    func changeSelectedLanguge(_ language: String) {
        self.selectedLanguage = language
        Bundle.setLanguage(lang: language)
    }
    
    func changeTheme(_ theme: ColorScheme) {
        self.selectedTheme = theme
        colorSchemeRawValue = theme == .light ? "light" : "dark"
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
