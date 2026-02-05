

final class AppEnvironment {
    static let shared = AppEnvironment()

    let recipeRepository: RecipeRepositoryProtocol

    private init() {
        recipeRepository = RecipeRepository(apiClient: APIClient())
    }
}
