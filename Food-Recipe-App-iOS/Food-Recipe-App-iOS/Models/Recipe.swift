import Foundation

struct Recipe: Identifiable, Codable,Hashable {

    let id: Int
    let name: String
    let ingredients: [String]
    let instructions: [String]
    let cookTimeMinutes: Int
    let difficulty: String
    let cuisine: String
    let userId: Int
    let image: String
    let rating: Double
    let reviewCount: Int
    let mealType: [String]
}
