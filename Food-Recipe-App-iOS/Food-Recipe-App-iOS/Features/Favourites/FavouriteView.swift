import SwiftUI

struct FavoritesView: View {

    @EnvironmentObject var viewModel: FavoritesViewModel
    @EnvironmentObject var homeVM: HomeViewModel


    var body: some View {

        NavigationStack {
            
            ScrollView {
                if viewModel.favorites.isEmpty {
                    Text("No recipes in favorites yet")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical,10)
                } else {
                    LazyVStack(spacing: 16) {
                        
                        ForEach(viewModel.favorites) { recipe in
                            
                            NavigationLink {
                                RecipeDetailView(
                                    recipe: recipe,
                                    allRecipes: homeVM.recipes
                                )
                            } label: {
                                FavoriteRow(recipe: recipe)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Favorites")
        }
        .task {
            await viewModel.load()
        }
    }
}
