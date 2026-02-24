import Foundation
import Combine


@MainActor
final class RecipeDetailViewModel: ObservableObject {
    enum Tab {
        case ingredients
        case procedure
        case similar
    }
    enum SimilarFilter: String, CaseIterable {
        case cuisine = "Cuisine"
        case mealType = "Meal Type"
    }
    @Published var selectedSimilarFilter: SimilarFilter = .cuisine
    @Published var selectedTab: Tab = .ingredients
    @Published var isSaved: Bool = false
    @Published var userRating: Int = 0

    let recipe: Recipe
    let allRecipes: [Recipe]

    init(recipe: Recipe, allRecipes: [Recipe]) {
        self.recipe = recipe
        self.allRecipes = allRecipes
        self.userRating = Int(round(recipe.rating))
    }
    
    var cuisineSimilarRecipes: [Recipe] {
        allRecipes.filter {
            $0.cuisine == recipe.cuisine && $0.id != recipe.id
        }
    }

    var mealTypeSimilarRecipes: [Recipe] {
        allRecipes.filter {
            !$0.mealType.isEmpty &&
            !recipe.mealType.isEmpty &&
            Set($0.mealType).intersection(recipe.mealType).isEmpty == false &&
            $0.id != recipe.id
        }
    }

    var currentSimilarRecipes: [Recipe] {
        switch selectedSimilarFilter {
        case .cuisine:
            return cuisineSimilarRecipes
        case .mealType:
            return mealTypeSimilarRecipes
        }
    }

    var hasAnySimilarity: Bool {
        !cuisineSimilarRecipes.isEmpty || !mealTypeSimilarRecipes.isEmpty
    }

    func toggleSave() {
        isSaved.toggle()
    }

    func selectTab(_ tab: Tab) {
        selectedTab = tab
    }

    func setRating(_ rating: Int) {
        userRating = rating
    }
}

