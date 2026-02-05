
//
//  RecipeRepositoryProtocol.swift
//  Food-Recipe-App-iOS
//
//  Created by rentamac on 2/4/26.
//


import Foundation

protocol RecipeRepositoryProtocol {
    func fetchRecipes() async throws -> [Recipe]
}

final class RecipeRepository: RecipeRepositoryProtocol {

    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchRecipes() async throws -> [Recipe] {
        let response: RecipeResponse = try await apiClient.request(
            endpoint: Endpoints.recipes
        )
        return response.recipes
    }
}
