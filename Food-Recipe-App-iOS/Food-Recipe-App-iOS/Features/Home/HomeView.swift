import SwiftUI

struct HomeView: View {

    @StateObject private var viewModel: HomeViewModel

    init(repository: RecipeRepositoryProtocol) {
        _viewModel = StateObject(
            wrappedValue: HomeViewModel(repository: repository)
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                headerSection
                searchSection
                categorySection
                popularRecipesSection
                newRecipesSection
            }
            .padding()
        }
        .task {
            await viewModel.loadRecipes()
        }
    }
}

extension HomeView {

    var headerSection: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Hello 👋")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text("What are you cooking today?")
                    .font(.title2)
                    .bold()
            }

            Spacer()

            Image(systemName: "person.crop.circle.fill")
                .font(.largeTitle)
                .foregroundColor(.green)
        }
    }

    var searchSection: some View {
        HStack {
            TextField("Search recipes", text: $viewModel.searchText)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)

            Button {
                // filter action
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
    }

    var categorySection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(viewModel.categories, id: \.self) { category in
                    Text(category)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            viewModel.selectedCategory == category
                            ? Color.green
                            : Color(.systemGray6)
                        )
                        .foregroundColor(
                            viewModel.selectedCategory == category
                            ? .white
                            : .primary
                        )
                        .cornerRadius(20)
                        .onTapGesture {
                            viewModel.selectedCategory = category
                        }
                }
            }
        }
    }

    var popularRecipesSection: some View {
        VStack(alignment: .leading) {
            Text("Popular Recipes")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.filteredRecipes.prefix(10)) { recipe in
                        RecipeRowView(recipe: recipe)
                    }
                }
            }
        }
    }

    var newRecipesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("New Recipes")
                .font(.headline)

            LazyVStack(spacing: 16) {
                ForEach(viewModel.filteredRecipes.prefix(10)) { recipe in
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

                        Image(systemName: "bookmark")
                            .foregroundColor(.green)
                    }
                }
            }
        }
    }

}
