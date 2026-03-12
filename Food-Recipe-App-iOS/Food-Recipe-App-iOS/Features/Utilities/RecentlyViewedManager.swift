//
//  RecentlyViewedManager.swift
//  Food-Recipe-App-iOS
//
//  Created by rentamac on 3/9/26.
//

import Foundation

class RecentlyViewedManager {

    static let shared = RecentlyViewedManager()

    private let key = "recentRecipes"
    private let maxItems = 10

    func add(recipeId: String) {

        var ids = getRecentIds()

        ids.removeAll { $0 == recipeId }

        ids.insert(recipeId, at: 0)

        if ids.count > maxItems {
            ids.removeLast()
        }

        UserDefaults.standard.set(ids, forKey: key)
    }
    
    func clear() {
        
        UserDefaults.standard.removeObject(forKey: key)
    }

    func getRecentIds() -> [String] {
        UserDefaults.standard.stringArray(forKey: key) ?? []
    }
}
