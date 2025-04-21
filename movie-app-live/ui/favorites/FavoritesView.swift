import SwiftUI

protocol FavoritesViewModelProtocol: ObservableObject {
    
}

class FavoritesViewModel: FavoritesViewModelProtocol {
    
}

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    
    var body: some View {
        NavigationView {
            Text("Favorites Screen")
                .navigationTitle("Favorites")
        }
    }
}

#Preview {
    FavoritesView()
} 