import Foundation

@MainActor
final class EditRecipeViewModel: ObservableObject {

    @Published var name: String
    @Published var cuisine: String
    @Published var cookTime: String
    @Published var imageURL: String
    @Published var difficulty: String
    @Published var ingredients: [String]
    @Published var instructions: [String]

    private let service = RecipeService()
    private let originalRecipe: Recipe

    init(recipe: Recipe) {
        self.originalRecipe = recipe
        self.name = recipe.name
        self.cuisine = recipe.cuisine
        self.cookTime = String(recipe.cookTimeMinutes)
        self.imageURL = recipe.image
        self.difficulty = recipe.difficulty
        self.ingredients = recipe.ingredients
        self.instructions = recipe.instructions
    }

    func updateRecipe() async throws {

        let updatedRecipe = Recipe(
            id: originalRecipe.id,
            name: name,
            ingredients: ingredients,
            instructions: instructions,
            cookTimeMinutes: Int(cookTime) ?? 0,
            difficulty: difficulty,
            cuisine: cuisine,
            userId: originalRecipe.userId,
            image: imageURL,
            rating: originalRecipe.rating,
            reviewCount: originalRecipe.reviewCount,
            mealType: originalRecipe.mealType
        )

        try await service.updateRecipe(recipe: updatedRecipe)
    }
}
