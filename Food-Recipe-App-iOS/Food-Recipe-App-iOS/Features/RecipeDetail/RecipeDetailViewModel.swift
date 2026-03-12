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
    let allRecipes: [Recipe]

    init(recipe: Recipe, allRecipes: [Recipe]) {
        self.recipe = recipe
        self.allRecipes = allRecipes
        self.userRating = Int(round(recipe.rating))
    }
    

    var mealTypeSimilarRecipes: [Recipe] {
        allRecipes.filter {
            !$0.mealType.isEmpty &&
            !recipe.mealType.isEmpty &&
            Set($0.mealType)
                .intersection(recipe.mealType)
                .isEmpty == false &&
            $0.id != recipe.id
        }
        .sorted { $0.rating > $1.rating }
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

