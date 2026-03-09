
import Foundation

protocol FavoritesRepositoryProtocol {
    func add(recipe: Recipe) async throws
    func remove(recipeId: Int) async throws
    func fetch() async throws -> [Recipe]
}

final class FavoritesRepository: FavoritesRepositoryProtocol {

    private let service = FavoritesService()

    func add(recipe: Recipe) async throws {
        try await service.addFavorite(recipe: recipe)
    }

    func remove(recipeId: Int) async throws {
        try await service.removeFavorite(recipeId: recipeId)
    }

    func fetch() async throws -> [Recipe] {
        try await service.fetchFavorites()
    }
}
