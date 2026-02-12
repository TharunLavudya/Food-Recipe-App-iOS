//
//  RecipeService.swift
//  Food-Recipe-App-iOS
//
//  Created by rentamac on 2/11/26.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class RecipeService {

    private let db = Firestore.firestore()

    private var uid: String? {
        Auth.auth().currentUser?.uid
    }
}
extension RecipeService {

    func addRecipe(recipe: Recipe) async throws {

        guard let uid = uid else { return }

        try await db
            .collection("users")
            .document(uid)
            .collection("recipes")
            .document(String(recipe.id))
            .setData([
                "name": recipe.name,
                "ingredients": recipe.ingredients,
                "instructions": recipe.instructions,
                "cookTimeMinutes": recipe.cookTimeMinutes,
                "difficulty": recipe.difficulty,
                "cuisine": recipe.cuisine,
                "image": recipe.image,
                "rating": recipe.rating,
                "reviewCount": recipe.reviewCount,
                "mealType": recipe.mealType,
                "createdAt": Timestamp(),
                "isPublic": true
            ])
    }
}
