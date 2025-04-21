import SwiftUI

protocol SearchViewModelProtocol: ObservableObject {
    
}

class SearchViewModel: SearchViewModelProtocol {
    
}

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationView {
            Text("Search Screen")
                .navigationTitle("Search")
        }
    }
}

#Preview {
    SearchView()
} 