import Foundation
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {

    @Published var allCuisines: [Cuisine] = []
    @Published var selectedCuisines: [Cuisine] = []
    @Published var isShowingCuisinePicker = false
    @Published var isLoading = false
    @Published var recipes: [Recipe] = []
    @Published var isLoading1 = false
    
    private let service = RecipeService()
    private let repository: RecipeRepositoryProtocol
    
    init(repository: RecipeRepositoryProtocol =
         RecipeRepository(networking: HttpNetworking())) {
        self.repository = repository
    }

    
    func fetchCuisines() async {
        guard allCuisines.isEmpty else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            allCuisines = try await repository.fetchCuisines()
        } catch {
            print("Cuisine fetch failed:", error)
        }
    }

    func toggleCuisine(_ cuisine: Cuisine) {
        if selectedCuisines.contains(cuisine) {
            selectedCuisines.removeAll { $0 == cuisine }
        } else {
            selectedCuisines.append(cuisine)
        }
    }
    func deleteRecipe(_ recipe: Recipe) async {

        do {
            try await service.deleteRecipe(recipeId: recipe.id)
            recipes.removeAll { $0.id == recipe.id }
        } catch {
            print("Delete failed:", error)
        }
    }

    
    func load() async {

            isLoading1 = true

            do {
                recipes =
                    try await service.fetchUserRecipes()
            } catch {
                print("Fetch user recipes error:", error)
            }

            isLoading1 = false
        }
}



