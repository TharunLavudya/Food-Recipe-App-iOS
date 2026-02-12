import SwiftUI

struct RecipeDetailView: View {

    @StateObject private var viewModel: RecipeDetailViewModel
    @EnvironmentObject var favoritesVM: FavoritesViewModel
    @EnvironmentObject var homeVM: HomeViewModel

    init(recipe: Recipe, allRecipes: [Recipe]) {
        _viewModel = StateObject(
            wrappedValue: RecipeDetailViewModel(
                recipe: recipe,
                allRecipes: allRecipes
            )
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AsyncImage(url: URL(string: viewModel.recipe.image)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(height: 220)
                .cornerRadius(20)

                VStack(alignment: .leading, spacing: 6) {
                    Text(viewModel.recipe.name)
                        .font(.title2)
                        .bold()

                    HStack(spacing: 4) {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: star <= viewModel.userRating ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .onTapGesture {
                                    viewModel.setRating(star)
                                }
                        }

                        Text(String(format: "%.1f", viewModel.recipe.rating))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Text("\(viewModel.recipe.cookTimeMinutes) mins")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                HStack {
                    Label("\(viewModel.recipe.cookTimeMinutes) min", systemImage: "clock")
                        .font(.caption)

                    Spacer()

                    Button {
                        Task {
                            await favoritesVM.toggle(recipe: viewModel.recipe)
                        }
                    } label: {
                        Image(systemName:
                                favoritesVM.isFavorite(viewModel.recipe)
                                ? "heart.fill"
                                : "heart"
                        )
                        .foregroundColor(.green)
                    }
                }
                HStack {
                    tabButton(title: "Ingredients", tab: .ingredients)
                    tabButton(title: "Procedure", tab: .procedure)
                    tabButton(title: "More like this", tab: .similar)
                }
                .padding(4)
                .background(Color(.systemGray6))
                .cornerRadius(12)

                VStack(alignment: .leading, spacing: 12) {

                    if viewModel.selectedTab == .ingredients {
                        ForEach(viewModel.recipe.ingredients, id: \.self) { ingredient in
                            Text("• \(ingredient)")
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                        }
                    }

                    else if viewModel.selectedTab == .procedure {
                        ForEach(viewModel.recipe.instructions.indices, id: \.self) { index in
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Step \(index + 1)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)

                                Text(viewModel.recipe.instructions[index])
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                    }

                    else {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.relatedRecipes.prefix(5)) { recipe in
                                NavigationLink {
                                    RecipeDetailView(
                                        recipe: recipe,
                                        allRecipes: homeVM.recipes
                                    )
                                } label: {
                                    HStack(spacing: 12) {

                                        AsyncImage(url: URL(string: recipe.image)) { image in
                                            image.resizable()
                                        } placeholder: {
                                            Color.gray.opacity(0.3)
                                        }
                                        .frame(width: 80, height: 80)
                                        .cornerRadius(12)

                                        VStack(alignment: .leading) {
                                            Text(recipe.name)
                                                .font(.headline)

                                            Text("\(recipe.cookTimeMinutes) mins")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }

                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func tabButton(
        title: String,
        tab: RecipeDetailViewModel.Tab
    ) -> some View {
        Text(title)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                viewModel.selectedTab == tab ? Color.green : Color.clear
            )
            .foregroundColor(
                viewModel.selectedTab == tab ? .white : .primary
            )
            .cornerRadius(10)
            .onTapGesture {
                viewModel.selectTab(tab)
            }
    }
}

