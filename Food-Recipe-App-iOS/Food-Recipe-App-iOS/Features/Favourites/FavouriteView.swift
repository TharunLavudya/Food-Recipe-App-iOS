import SwiftUI

struct FavoritesView: View {

    @Binding var selectedTab: Int
    @EnvironmentObject var viewModel: FavoritesViewModel
    @EnvironmentObject var homeVM: HomeViewModel


    var body: some View {

        NavigationStack {
            
            ScrollView {

                if viewModel.favorites.isEmpty {

                    emptyStateView

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

extension FavoritesView {
    private var emptyStateView: some View {
        VStack(spacing: 20) {

            Spacer()

            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.15))
                    .frame(width: 120, height: 120)

                Image(systemName: "heart.slash.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.green)
            }

            Text("No Favorites Yet")
                .font(.title2.bold())

            Text("Start exploring recipes and tap the heart icon to save your favorites here.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Button {
                selectedTab = 0
            } label: {
                Text("Explore Recipes")
                    .fontWeight(.semibold)
                    .padding()
                    .frame(width: 200)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(14)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}
