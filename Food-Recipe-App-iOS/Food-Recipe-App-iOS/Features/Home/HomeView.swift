import SwiftUI

struct HomeView: View {

    @StateObject private var viewModel: HomeViewModel
    @Binding var selectedTab: Int
    @ObservedObject var authViewModel: AuthViewModel
    @EnvironmentObject var favoritesVM: FavoritesViewModel
    @State private var navigateToSearchWithFilter = false


    init(
            repository: RecipeRepositoryProtocol,
            selectedTab: Binding<Int>,
            authViewModel: AuthViewModel,
            
        ) {
            _viewModel = StateObject(
                wrappedValue: HomeViewModel(repository: repository)
            )
            _selectedTab = selectedTab
            self.authViewModel = authViewModel
        }

    var body: some View {
        NavigationStack {
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
}

extension HomeView {

    var headerSection: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Hello \(authViewModel.username)")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .bold()

                Text("What are you cooking today?")
                    .font(.title2)
                    
            }

            Spacer()

            Image(homeProfileImage)
                .resizable()
                .scaledToFill()
                .frame(width: 36, height: 36)
                .clipShape(Circle())
                .contentShape(Circle())
                .foregroundColor(.green)
                .onTapGesture {
                        selectedTab = 4
                    }
        }
    }

    var searchSection: some View {
        HStack(spacing: 12) {

            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)

                Text("Search recipes")
                    .foregroundColor(.gray)

                Spacer()
            }
            .padding(.horizontal, 12)
            .frame(height: 44)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .onTapGesture {
                selectedTab = 1
            }

            NavigationLink(destination: FilterView(filter: $viewModel.filter)) {
                Image(systemName: "slider.horizontal.3")
                    .frame(width: 44, height: 44)
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
                        NavigationLink {
                            RecipeDetailView(
                                recipe: recipe,
                                allRecipes: viewModel.recipes
                            )
                        } label: {
                            RecipeRowView(recipe: recipe)
                        }
                        .buttonStyle(.plain)
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
                    NavigationLink {
                        RecipeDetailView(
                            recipe: recipe,
                            allRecipes: viewModel.recipes
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

                            Button {
                                Task {
                                    await favoritesVM.toggle(recipe: recipe)
                                }
                            } label: {
                                Image(systemName:
                                        favoritesVM.isFavorite(recipe)
                                        ? "heart.fill"
                                        : "heart"
                                )
                                .foregroundColor(.green)
                            }

                        }
                    }
                    .buttonStyle(.plain)                   
                }
            }
        }
    }
    var homeProfileImage: String {
       switch authViewModel.gender {
       case "Male":
           return "male"
       case "Female":
           return "female"
       default:
           return "default"
       }
   }
}





