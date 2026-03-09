//
//import Foundation
//import Combine
//
//@MainActor
//final class SearchViewModel: ObservableObject {
//
//    @Published var recipes: [Recipe] = []
//
//    @Published var filter: RecipeFilter = .empty
//
//    @Published var searchText: String = ""
//
//    private let repository: RecipeRepositoryProtocol
//
//    init(repository: RecipeRepositoryProtocol) {
//        self.repository = repository
//    }
//
//    func loadRecipes() async {
//        do {
//            recipes = try await repository.fetchRecipes()
//           
//        } catch {
//            print("Error loading recipes:", error)
//        }
//    }
//    
//
//
//
//    var filteredRecipes: [Recipe] {
//
//        recipes.filter { recipe in
//
//            // Search
//            let matchesSearch =
//                searchText.isEmpty ||
//                recipe.name.localizedCaseInsensitiveContains(searchText) ||
//                recipe.cuisine.localizedCaseInsensitiveContains(searchText)
//
//            // Cook Time
//            let matchesCookTime =
//                filter.cookTimeRanges.isEmpty ||
//                filter.cookTimeRanges.contains { $0.contains(recipe.cookTimeMinutes) }
//
//            // Servings
////            let matchesServings =
////                filter.servingsRanges.isEmpty ||
////                filter.servingsRanges.contains { $0.contains(recipe.servings) }
//
//            // Rating
//            let matchesRating =
//                filter.minRatings.isEmpty ||
//                filter.minRatings.contains { recipe.rating >= $0 }
//
//            // Cuisine
//            let matchesCuisine =
//                filter.cuisines.isEmpty ||
//                filter.cuisines.contains(recipe.cuisine)
//
//            // Calories
////            let matchesCalories =
////                filter.calorieRanges.isEmpty ||
////                filter.calorieRanges.contains { $0.contains(recipe.caloriesPerServing) }
//
//            return matchesSearch &&
//                   matchesCookTime &&
////                   matchesServings &&
//                   matchesRating &&
//                   matchesCuisine 
////                   matchesCalories
//        }
//    }
//
//}
//


import Foundation
import Combine

@MainActor
final class SearchViewModel: ObservableObject {

    @Published var recipes: [Recipe] = []
    @Published var filter: RecipeFilter = .empty
    @Published var searchText: String = ""
    
    // ✅ Add this
    @Published var allCuisines: [String] = []

    private let repository: RecipeRepositoryProtocol

    init(repository: RecipeRepositoryProtocol) {
        self.repository = repository
    }

    func loadRecipes() async {
        do {
            recipes = try await repository.fetchRecipes()
            
            // populate dynamic cuisines
            let cuisines = recipes.map { $0.cuisine }
            allCuisines = Array(Set(cuisines)).sorted()
            
        } catch {
            print("Error loading recipes:", error)
        }
    }

    var filteredRecipes: [Recipe] {
        recipes.filter { recipe in

            // Search
            let matchesSearch =
                searchText.isEmpty ||
                recipe.name.localizedCaseInsensitiveContains(searchText) ||
                recipe.cuisine.localizedCaseInsensitiveContains(searchText)

            // Cook Time
            let matchesCookTime =
                filter.cookTimeRanges.isEmpty ||
                filter.cookTimeRanges.contains { $0.contains(recipe.cookTimeMinutes) }

            // Rating
            let matchesRating =
                filter.minRatings.isEmpty ||
                filter.minRatings.contains { recipe.rating >= $0 }

            // Cuisine
            let matchesCuisine =
                filter.cuisines.isEmpty ||
                filter.cuisines.contains(recipe.cuisine)

            // MealType & Difficulty (if you added these fields to Recipe)
            let matchesMealType =
                filter.mealTypes.isEmpty || filter.mealTypes.contains(recipe.mealType)
            let matchesDifficulty =
                filter.difficultyLevels.isEmpty || filter.difficultyLevels.contains(recipe.difficulty)

            return matchesSearch &&
                   matchesCookTime &&
                   matchesRating &&
                   matchesCuisine &&
                   matchesMealType &&
                   matchesDifficulty
        }
    }
}
