import Foundation
import SwiftUI
import InjectPropertyWrapper

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
    
    @Published var appInfo: String = ""
    
    @Inject
    private var appVersionProvider: AppVersionProviderProtocol
    
    private let languageManager = LanguageManager.shared
    
    init() {
        let storedThem = UserDefaults.standard.string(forKey: "color-scheme")
        self.selectedTheme = Theme(rawValue: storedThem ?? "") ?? .light
        
        appInfo = appVersionProvider.version + " (" + appVersionProvider.build + ")"
    }
    
    func changeSelectedLanguge(_ language: String) {
        self.selectedLanguage = language
        languageManager.setLanguage(language)
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
