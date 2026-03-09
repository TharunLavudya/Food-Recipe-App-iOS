import Combine
import Foundation
import FirebaseAuth


@MainActor
final class HomeViewModel: ObservableObject {

    @Published var recipes: [Recipe] = []
    @Published var categories: [String] = ["All"]
    @Published var selectedCategory: String = "All"
    @Published var searchText: String = ""
    @Published var allCuisines: [String] = []
    @Published var allMealTypes: [String] = []
    
    @Published var filter: RecipeFilter = .empty

    private let repository: RecipeRepositoryProtocol
    
    private let userService = UserService()
    private let recipeService = RecipeService()
    
    @Published var userInterests: [String] = []
    @Published var interestRecipes: [Recipe] = []
    @Published var recentlyViewed: [Recipe] = []
    @Published var userRecipes: [Recipe] = []
    init(repository: RecipeRepositoryProtocol) {
        self.repository = repository
    }

    func loadRecipes() async {
        do {
            recipes = try await repository.fetchRecipes()
            userRecipes = try await recipeService.fetchUserRecipes()
            setupCategories()
            setupCuisines()
            setupMealTypes()
            loadRecentlyViewed()
            
            userInterests = try await userService.fetchUserInterests()
            filterInterestRecipes()
        } catch {
            print("Failed to load recipes:", error)
        }
    }
    
   
    func loadRecentlyViewed() {

        let ids = RecentlyViewedManager.shared.getRecentIds()

        let allRecipes = recipes + userRecipes

        recentlyViewed = ids.compactMap { id in
            guard let intId = Int(id) else { return nil }
            return allRecipes.first(where: { $0.id == intId })
        }
    }
    
    private func setupMealTypes() {
        let types = recipes.flatMap { $0.mealType }
        allMealTypes = Array(Set(types)).sorted()
    }
    
    private func filterInterestRecipes() {

        guard !userInterests.isEmpty else {
            interestRecipes = []
            return
        }

        interestRecipes = recipes.filter {
                userInterests.contains($0.cuisine)
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
    
    
    // Popular Recipes
    var popularRecipes: [Recipe] {
        filteredRecipes
            .sorted {
                $0.rating > $1.rating
            }
    }
    
    // New Recipes
    var newRecipes: [Recipe] {
        filteredRecipes
            .sorted {
                $0.id > $1.id  
            }
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

