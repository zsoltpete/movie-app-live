import SwiftUI

protocol SettingsViewModelProtocol: ObservableObject {
    
}

class SettingsViewModel: SettingsViewModelProtocol {
    
}

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationView {
            Text("Settings Screen")
                .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
} 