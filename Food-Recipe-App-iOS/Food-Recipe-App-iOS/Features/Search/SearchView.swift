import SwiftUI

struct SearchView: View {

    @StateObject private var viewModel: SearchViewModel
    @Binding var selectedTab: Int
    @State private var showFilter = false

    init(
        repository: RecipeRepositoryProtocol,
        selectedTab: Binding<Int>
    ) {
        _viewModel = StateObject(
            wrappedValue: SearchViewModel(repository: repository)
        )
        _selectedTab = selectedTab
    }

    var body: some View {

        NavigationStack {

            VStack {
            
                HStack {

                    TextField("Search by recipe or cuisine",
                              text: $viewModel.searchText)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)

                    NavigationLink(destination: FilterView(filter: $viewModel.filter)) {
                        Image(systemName: "slider.horizontal.3")
                            .frame(width: 44, height: 44)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    

                }
                .padding()

                
                Text("\(viewModel.filteredRecipes.count) Results")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)

                if viewModel.filteredRecipes.isEmpty {

                    Spacer()

                    VStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .font(.largeTitle)
                            .foregroundColor(.gray)

                        Text("No Recipes Found")
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                } else {

                    List(viewModel.filteredRecipes) { recipe in

                        NavigationLink {
                            RecipeDetailView(
                                recipe: recipe,
                                allRecipes: viewModel.recipes
                            )
                        } label: {

                            HStack(spacing: 12) {

                                AsyncImage(url: URL(string: recipe.image)) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 80, height: 80)
                                .clipped()
                                .cornerRadius(12)

                                VStack(alignment: .leading, spacing: 6) {

                                    Text(recipe.name)
                                        .font(.headline)

                                    Text(recipe.cuisine)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)

                                    Text("\(recipe.cookTimeMinutes) mins")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }

                                Spacer()
                            }
                            .padding(.vertical, 6)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Search")
            
//            .toolbar {
//                ToolbarItem(placement: .topBarLeading) {
//                    Button {
//                        selectedTab = 0
//                    } label: {
//                        Image(systemName: "chevron.left")
//                    }
//                }
//            }

            .sheet(isPresented: $showFilter) {
                SortFilterView(filter: $viewModel.filter)
            }

            .task {
                await viewModel.loadRecipes()
            }
        }
    }
}

