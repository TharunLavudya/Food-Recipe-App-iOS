import Foundation
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {

    @Published var allCuisines: [Cuisine] = []
    @Published var selectedCuisines: [Cuisine] = []
    @Published var isShowingCuisinePicker = false
    @Published var isLoading = false
    @Published var recipes: [Recipe] = []
    private let service = RecipeService()
    @Published var isLoading1 = false
    
    func fetchCuisines() async {
        guard allCuisines.isEmpty else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            let url = URL(string: "https://dummyjson.com/recipes")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(RecipeResponse.self, from: data)
            // Extracting unique cuisines and maping them to Cuisine models
            let cuisines = Set(response.recipes.map { $0.cuisine })
                .sorted()
                .map { Cuisine(name: $0) }
            self.allCuisines = cuisines
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


