
import Combine
import Foundation

@MainActor
final class HomeViewModel: ObservableObject {

    @Published var recipes: [Recipe] = []
    @Published var categories: [String] = ["All"]
    @Published var selectedCategory: String = "All"
    @Published var searchText: String = ""

    private let repository: RecipeRepositoryProtocol

    init(repository: RecipeRepositoryProtocol) {
        self.repository = repository
    }

    func loadRecipes() async {
        do {
            recipes = try await repository.fetchRecipes()
            setupCategories()
        } catch {
            print("Failed to load recipes:", error)
        }
    }
    
    private func setupCategories() {

        let cuisines = recipes.map { $0.cuisine }

        let uniqueCuisines = Set(cuisines)
            .sorted()

        categories = ["All"] + uniqueCuisines
    }
    
    var filteredRecipes: [Recipe] {
        recipes.filter {
            (selectedCategory == "All" || $0.cuisine == selectedCategory) &&
            (searchText.isEmpty ||
             $0.name.localizedCaseInsensitiveContains(searchText))
        }
    }

}
