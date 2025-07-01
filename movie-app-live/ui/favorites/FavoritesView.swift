import SwiftUI
import InjectPropertyWrapper

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    
    @EnvironmentObject private var langaugeManager: LanguageManager
    
    var body: some View {
        let items = viewModel.mediaItems
        NavigationView {
            Group {
                if items.isEmpty {
                    VStack(spacing: LayoutConst.largePadding) {
                        Spacer()
                        Text("No favorites yet")
                            .font(Fonts.heading)
                        Text("Add some favorites by searching for movies or TV shows")
                            .font(Fonts.detailsButton)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    .padding(.horizontal, LayoutConst.normalPadding)
                } else {
                    ScrollView {
                        LazyVStack(spacing: LayoutConst.normalPadding) {
                            ForEach(viewModel.mediaItems.indices, id: \.self) { index in
                                let movie = viewModel.mediaItems[index]
                                NavigationLink(destination: DetailView(mediaItem: movie)) {
                                    MediaItemCell(movie: movie)
                                        .frame(height: 277)
                                    
                                }
                                .buttonStyle(PlainButtonStyle())
                                .accessibilityLabel("MediaItem\(index)")
                            }
                        }
                        .padding(.horizontal, LayoutConst.normalPadding)
                        .padding(.top, LayoutConst.normalPadding)
                    }
                }
                
            }
            .navigationTitle("favoriteMovies.title".localized())
            .accessibilityLabel(AccessibilityLabels.favoritesScrollView)
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
