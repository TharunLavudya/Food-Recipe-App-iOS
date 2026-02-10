import Foundation
import Combine

@MainActor
final class RecipeDetailViewModel: ObservableObject {
    enum Tab {
        case ingredients
        case procedure
        case similar
    }
    @Published var selectedTab: Tab = .ingredients
    @Published var isSaved: Bool = false
    @Published var userRating: Int = 0

    let recipe: Recipe
    let relatedRecipes: [Recipe]

    init(recipe: Recipe, allRecipes: [Recipe]) {
        self.recipe = recipe
        self.relatedRecipes = allRecipes.filter {
            $0.cuisine == recipe.cuisine && $0.id != recipe.id
        }

        self.userRating = Int(round(recipe.rating))
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

