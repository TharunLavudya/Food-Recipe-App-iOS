
final class AppEnvironment {

    static let shared = AppEnvironment()

    let networking: Networking
    let recipeRepository: RecipeRepositoryProtocol

    private init() {

        networking = HttpNetworking()

        recipeRepository = RecipeRepository(
            networking: networking
        )
    }
}

