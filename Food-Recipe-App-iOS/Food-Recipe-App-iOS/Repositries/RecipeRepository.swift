
//
//  RecipeRepositoryProtocol.swift
//  Food-Recipe-App-iOS
//
//  Created by rentamac on 2/4/26.
//
import Foundation

protocol RecipeRepositoryProtocol {
    func fetchRecipes() async throws -> [Recipe]
    func fetchCuisines() async throws -> [Cuisine]
}

final class RecipeRepository: RecipeRepositoryProtocol {

    private let networking: Networking

    init(networking: Networking) {
        self.networking = networking
    }
    
    func fetchRecipes() async throws -> [Recipe] {

        let response: RecipeResponse =
        try await networking.request(
            endpoint: RecipeEndpoint.getRecipes,
            responseType: RecipeResponse.self
        )

        return response.recipes
    }

    func searchRecipes(query: String) async throws -> [Recipe] {

        let response: RecipeResponse =
        try await networking.request(
            endpoint: RecipeEndpoint.searchRecipes(query: query),
            responseType: RecipeResponse.self
        )
        return response.recipes
    }
    
    func fetchCuisines() async throws -> [Cuisine] {

        let response: RecipeResponse =
        try await networking.request(
            endpoint: RecipeEndpoint.getRecipes,
            responseType: RecipeResponse.self
        )

        let cuisines = Set(response.recipes.map { $0.cuisine })
            .sorted()
            .map { Cuisine(name: $0) }

        return cuisines
    }

    
}

