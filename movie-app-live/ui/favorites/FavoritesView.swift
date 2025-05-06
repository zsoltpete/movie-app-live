import SwiftUI
import InjectPropertyWrapper

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: LayoutConst.normalPadding) {
                    ForEach(viewModel.movies) { movie in
                        MovieCell(movie: movie)
                            .frame(height: 277)
                    }
                }
                .padding(.horizontal, LayoutConst.normalPadding)
                .padding(.top, LayoutConst.normalPadding)
            }
            .navigationTitle("favoriteMovies.title")
        }
        .alert(item: $viewModel.alertModel) { model in
            
            Alert(
                title: Text(LocalizedStringKey(model.title)),
                message: Text(LocalizedStringKey(model.message)),
                primaryButton: .default(Text(LocalizedStringKey(model.dismissButtonTitle))) {
                    
                }, secondaryButton: .destructive(Text(LocalizedStringKey(model.dismissButtonTitle))) {
                    
                }
            )
        }
    }
}

#Preview {
    FavoritesView()
} 
