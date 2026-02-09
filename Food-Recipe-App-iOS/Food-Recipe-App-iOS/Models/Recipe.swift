import Foundation

struct Recipe: Identifiable, Decodable {
    let id: Int
    let name: String
    let ingredients: [String]
    let instructions: [String]
    let cookTimeMinutes: Int
    let servings: Int
    let cuisine: String
    let caloriesPerServing: Int
    let rating: Double          
    let image: String
}

