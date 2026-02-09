import Foundation
import Combine

@MainActor
final class RecipeDetailViewModel: ObservableObject {

    enum Tab {
        case ingredients
        case procedure
        case similar

    }

    // MARK: - UI State
    @Published var selectedTab: Tab = .ingredients
    @Published var isSaved: Bool = false
    @Published var userRating: Int = 0     // ⭐ NEW

    // MARK: - Data
    let recipe: Recipe
    let relatedRecipes: [Recipe]

    // MARK: - Init
    init(recipe: Recipe, allRecipes: [Recipe]) {
        self.recipe = recipe
        self.relatedRecipes = allRecipes.filter {
            $0.cuisine == recipe.cuisine && $0.id != recipe.id
        }

        // ⭐ Initialize rating from API value
        self.userRating = Int(round(recipe.rating))
    }

    // MARK: - Actions
    func toggleSave() {
        isSaved.toggle()
    }

    func selectTab(_ tab: Tab) {
        selectedTab = tab
    }

    // ⭐ NEW: Update rating when user taps stars
    func setRating(_ rating: Int) {
        userRating = rating
    }
}

