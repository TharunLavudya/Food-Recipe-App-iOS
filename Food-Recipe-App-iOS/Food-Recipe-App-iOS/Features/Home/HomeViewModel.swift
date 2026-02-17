//
//import Combine
//import Foundation
//
//@MainActor
//final class HomeViewModel: ObservableObject {
//
//    @Published var recipes: [Recipe] = []
//    @Published var categories: [String] = ["All"]
//    @Published var selectedCategory: String = "All"
//    @Published var searchText: String = ""
//    
//    @Published var filter: RecipeFilter = .empty
//
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
//            setupCategories()
//        } catch {
//            print("Failed to load recipes:", error)
//        }
//    }
//    
//    private func setupCategories() {
//
//        let cuisines = recipes.map { $0.cuisine }
//
//        let uniqueCuisines = Set(cuisines)
//            .sorted()
//
//        categories = ["All"] + uniqueCuisines
//    }
//    
////    var filteredRecipes: [Recipe] {
////        recipes.filter {
////            (selectedCategory == "All" || $0.cuisine == selectedCategory) &&
////            (searchText.isEmpty ||
////             $0.name.localizedCaseInsensitiveContains(searchText))
////        }
////    }
//    
//    var filteredRecipes: [Recipe] {
//        recipes.filter { recipe in
//
//            // Category & Search
//            let matchesCategory = selectedCategory == "All" || recipe.cuisine == selectedCategory
//            let matchesSearch = searchText.isEmpty || recipe.name.localizedCaseInsensitiveContains(searchText)
//
//            // Filters
//            let matchesCookTime = filter.cookTimeRanges.isEmpty || filter.cookTimeRanges.contains { $0.contains(recipe.cookTimeMinutes) }
////            let matchesServings = filter.servingsRanges.isEmpty || filter.servingsRanges.contains { $0.contains(recipe.servings) }
//            let matchesRating = filter.minRatings.isEmpty || filter.minRatings.contains { recipe.rating >= $0 }
//            let matchesCuisine = filter.cuisines.isEmpty || filter.cuisines.contains(recipe.cuisine)
////            let matchesCalories = filter.calorieRanges.isEmpty || filter.calorieRanges.contains { $0.contains(recipe.caloriesPerServing) }
//
//            return matchesCategory && matchesSearch && matchesCookTime  && matchesRating && matchesCuisine 
//        }
//    }
//    
//    var filterIsEmpty: Bool {
//        filter.cookTimeRanges.isEmpty &&
//        filter.servingsRanges.isEmpty &&
//        filter.minRatings.isEmpty &&
//        filter.cuisines.isEmpty &&
//        filter.calorieRanges.isEmpty
//    }
//
//
//}
//



import Combine
import Foundation

@MainActor
final class HomeViewModel: ObservableObject {

    @Published var recipes: [Recipe] = []
    @Published var categories: [String] = ["All"]
    @Published var selectedCategory: String = "All"
    @Published var searchText: String = ""
    @Published var allCuisines: [String] = []
    
    @Published var filter: RecipeFilter = .empty

    private let repository: RecipeRepositoryProtocol

    init(repository: RecipeRepositoryProtocol) {
        self.repository = repository
    }

    func loadRecipes() async {
        do {
            recipes = try await repository.fetchRecipes()
            setupCategories()
            setupCuisines()
        } catch {
            print("Failed to load recipes:", error)
        }
    }
    
    private func setupCategories() {
        let cuisines = recipes.map { $0.cuisine }
        let uniqueCuisines = Set(cuisines).sorted()
        categories = ["All"] + uniqueCuisines
    }
    
    
    private func setupCuisines() {
        let cuisines = recipes.map { $0.cuisine }
        allCuisines = Array(Set(cuisines)).sorted()
    }
    
    
    
    var filteredRecipes: [Recipe] {
        
        
        
        recipes.filter { recipe in

            // Category & Search
            let matchesCategory = selectedCategory == "All" || recipe.cuisine == selectedCategory
            let matchesSearch = searchText.isEmpty || recipe.name.localizedCaseInsensitiveContains(searchText)

            // Filters
            let matchesCookTime = filter.cookTimeRanges.isEmpty || filter.cookTimeRanges.contains { $0.contains(recipe.cookTimeMinutes) }
            let matchesRating = filter.minRatings.isEmpty || filter.minRatings.contains { recipe.rating >= $0 }
            let matchesCuisine = filter.cuisines.isEmpty || filter.cuisines.contains(recipe.cuisine)
            let matchesMealType = filter.mealTypes.isEmpty || filter.mealTypes.contains(recipe.mealType)
            let matchesDifficulty = filter.difficultyLevels.isEmpty || filter.difficultyLevels.contains(recipe.difficulty)

            return matchesCategory && matchesSearch &&
                   matchesCookTime && matchesRating &&
                   matchesCuisine && matchesMealType &&
                   matchesDifficulty
        }
    }
    
    var filterIsEmpty: Bool {
        filter.cookTimeRanges.isEmpty &&
        filter.minRatings.isEmpty &&
        filter.cuisines.isEmpty &&
        filter.mealTypes.isEmpty &&
        filter.difficultyLevels.isEmpty
    }
}
