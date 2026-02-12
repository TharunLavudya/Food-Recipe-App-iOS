//
//  AddRecipeViewModel.swift
//  Food-Recipe-App-iOS
//
//  Created by rentamac on 2/12/26.
//

import Foundation
import FirebaseAuth
import Combine

@MainActor
final class AddRecipeViewModel: ObservableObject {

    @Published var name = ""
    @Published var cuisine = ""
    @Published var cookTime = ""
    @Published var imageURL = ""

    @Published var difficulty = "Easy"

    @Published var ingredients: [String] = [""]
    @Published var instructions: [String] = [""]

    @Published var isLoading = false
    @Published var successMessage: String?
    @Published var errorMessage: String?
    @Published var showSuccessPopup = false


    private let service = RecipeService()
    
    private func validate() -> Bool {

        if name.isEmpty {
            errorMessage = "Recipe name is required"
            return false
        }

        if cuisine.isEmpty {
            errorMessage = "Please select cuisine"
            return false
        }

        if cookTime.isEmpty {
            errorMessage = "Cook time is required"
            return false
        }

        if ingredients.contains(where: { $0.isEmpty }) {
            errorMessage = "All ingredients must be filled"
            return false
        }

        if instructions.contains(where: { $0.isEmpty }) {
            errorMessage = "All instructions must be filled"
            return false
        }

        return true
    }


    func addIngredient() {
        ingredients.append("")
    }

    func removeIngredient(at index: Int) {
        guard ingredients.count > 1 else { return }
        ingredients.remove(at: index)
    }

    func addInstruction() {
        instructions.append("")
    }

    func removeInstruction(at index: Int) {
        guard instructions.count > 1 else { return }
        instructions.remove(at: index)
    }
    
    func submitRecipe() async {

        errorMessage = nil

        guard validate() else { return }

        guard Auth.auth().currentUser != nil else {
            return
        }

        isLoading = true

        let recipe = Recipe(

            id: Int.random(in: 100000...999999),
            name: name,
            ingredients: ingredients,
            instructions: instructions,
            cookTimeMinutes: Int(cookTime) ?? 0,
            difficulty: difficulty,
            cuisine: cuisine,
            userId: 0,
            image: imageURL,
            rating: 0,
            reviewCount: 0,
            mealType: []
        )

        do {
            try await service.addRecipe(recipe: recipe)

            successMessage =
                "Recipe published successfully."
            showSuccessPopup = true

            clearForm()

        } catch {
            errorMessage =
                "Failed to publish recipe"
        }

        isLoading = false
    }
}

extension AddRecipeViewModel {
    private func clearForm() {
        
        name = ""
        cuisine = ""
        difficulty = ""
        cookTime = ""
        imageURL = ""
        
        ingredients = [""]
        instructions = [""]
    }
}

