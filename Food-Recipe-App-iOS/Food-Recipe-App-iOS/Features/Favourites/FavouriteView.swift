import SwiftUI

struct FavoritesView: View {

    @EnvironmentObject var viewModel: FavoritesViewModel
    @EnvironmentObject var homeVM: HomeViewModel


    var body: some View {

        NavigationStack {

            ScrollView {

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
            .navigationTitle("Favorites")
        }
        .task {
            await viewModel.load()
        }
    }
}
