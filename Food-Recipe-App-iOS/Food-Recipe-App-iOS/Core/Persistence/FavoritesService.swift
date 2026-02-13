//
//  FavoritesService.swift
//  Food-Recipe-App-iOS
//
//  Created by rentamac on 2/11/26.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class FavoritesService {

    private let db = Firestore.firestore()

    private var uid: String? {
        Auth.auth().currentUser?.uid
    }
}
extension FavoritesService {

    func addFavorite(recipe: Recipe) async throws {

        guard let uid = uid else { return }

        try await db
            .collection("users")
            .document(uid)
            .collection("favorites")
            .document(String(recipe.id))
            .setData([
                "id": recipe.id,
                "name": recipe.name,
                "ingredients": recipe.ingredients,
                "instructions": recipe.instructions,
                "cookTimeMinutes": recipe.cookTimeMinutes,
                "difficulty": recipe.difficulty,
                "cuisine": recipe.cuisine,
                "userId": recipe.userId,
                "image": recipe.image,
                "rating": recipe.rating,
                "reviewCount": recipe.reviewCount,
                "mealType": recipe.mealType,
                "favoritedAt": Timestamp()
            ])
    }
    func removeFavorite(recipeId: Int) async throws {

        guard let uid = uid else { return }

        try await db
            .collection("users")
            .document(uid)
            .collection("favorites")
            .document(String(recipeId))
            .delete()
    }
    func fetchFavorites() async throws -> [Recipe] {

        guard let uid = uid else { return [] }

        let snapshot = try await db
            .collection("users")
            .document(uid)
            .collection("favorites")
            .getDocuments()

        return snapshot.documents.compactMap { doc in

            let data = doc.data()

            return Recipe(
                id: data["id"] as? Int ?? 0,
                name: data["name"] as? String ?? "",
                ingredients: data["ingredients"] as? [String] ?? [],
                instructions: data["instructions"] as? [String] ?? [],
                cookTimeMinutes: data["cookTimeMinutes"] as? Int ?? 0,
                difficulty: data["difficulty"] as? String ?? "",
                cuisine: data["cuisine"] as? String ?? "",
                userId: data["userId"] as? Int ?? 0,
                image: data["image"] as? String ?? "",
                rating: data["rating"] as? Double ?? 0,
                reviewCount: data["reviewCount"] as? Int ?? 0,
                mealType: data["mealType"] as? [String] ?? []
            )
        }
    }
}
