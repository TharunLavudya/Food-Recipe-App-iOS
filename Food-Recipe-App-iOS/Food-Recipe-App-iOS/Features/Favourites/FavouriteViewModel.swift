import SwiftUI
import Foundation
import Combine

@MainActor
final class FavoritesViewModel: ObservableObject {

    @Published var favorites: [Recipe] = []

    private let repo: FavoritesRepositoryProtocol

    init(repo: FavoritesRepositoryProtocol) {
        self.repo = repo
    }

    func load() async {
        favorites = (try? await repo.fetch()) ?? []
    }
    
    func isFavorite(_ recipe: Recipe) -> Bool {
        favorites.contains { $0.id == recipe.id }
    }


    func toggle(recipe: Recipe) async {

        if favorites.contains(where: { $0.id == recipe.id }) {
            try? await repo.remove(recipeId: recipe.id)
        } else {
            try? await repo.add(recipe: recipe)
        }

        await load()
    }
}
