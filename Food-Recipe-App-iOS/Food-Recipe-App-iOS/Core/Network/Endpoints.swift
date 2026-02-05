

import Foundation

enum Endpoints {
    case recipes
}

extension Endpoints {

    var url: URL? {
        switch self {
        case .recipes:
            return URL(string: "https://dummyjson.com/recipes")
        }
    }
}
