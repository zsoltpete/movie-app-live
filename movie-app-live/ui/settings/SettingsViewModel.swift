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
    
    init() {
        let storedThem = UserDefaults.standard.string(forKey: "color-scheme")
        self.selectedTheme = Theme(rawValue: storedThem ?? "") ?? .light
        
        appInfo = appVersionProvider.version + " (" + appVersionProvider.build + ")"
    }
    
    func changeSelectedLanguge(_ language: String) {
        self.selectedLanguage = language
        Bundle.setLanguage(lang: language)
    }
    
    func changeTheme(_ theme: Theme) {
        self.selectedTheme = theme
    }
    
    func escapingMethond(closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            closure()
        }
    }
    
    func nonEscapingMethond(closure: () -> Void) {
        closure()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            //closure()
        }
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
