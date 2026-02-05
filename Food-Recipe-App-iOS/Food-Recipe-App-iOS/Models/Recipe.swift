

import Foundation

struct Recipe: Identifiable, Codable {
    let id: Int
    let name: String
    let image: String
    let rating: Double
    let cookTimeMinutes: Int
    let cuisine: String
}
