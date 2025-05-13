import SwiftUI
import InjectPropertyWrapper

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: LayoutConst.normalPadding) {
                    ForEach(viewModel.mediaItems) { movie in
                        NavigationLink(destination: DetailView(mediaItem: movie)) {
                            MovieCell(movie: movie)
                                .frame(height: 277)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, LayoutConst.normalPadding)
                .padding(.top, LayoutConst.normalPadding)
            }
            .navigationTitle("favoriteMovies.title")
        }
        .showAlert(model: $viewModel.alertModel)
        .onAppear {
            viewModel.viewLoaded.send(())
        }
    }
}

#Preview {
    FavoritesView()
} 
