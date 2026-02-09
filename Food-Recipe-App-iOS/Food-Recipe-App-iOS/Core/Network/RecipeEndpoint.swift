//
//  RecipeEndpoint.swift
//  Food-Recipe-App-iOS
//
//  Created by rentamac on 2/6/26.
//

import Foundation

enum RecipeEndpoint {
    case getRecipes
    case searchRecipes(query: String)
}

extension RecipeEndpoint: APIEndpoint {

    var baseURL: String {
        "https://dummyjson.com"
    }

    var path: String {
        switch self {
        case .getRecipes:
            return "/recipes"

        case .searchRecipes:
            return "/recipes/search"
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .getRecipes:
            return []
            
        case .searchRecipes(let query):
            return [
                URLQueryItem(name: "q", value: query)
            ]
        }
    }
}
