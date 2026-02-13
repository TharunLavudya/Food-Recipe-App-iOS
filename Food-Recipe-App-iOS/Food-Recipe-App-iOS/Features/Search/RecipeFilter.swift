//
//  RecipeFilter.swift
//  Food-Recipe-App-iOS
//
//  Created by rentamac on 2/11/26.
//


import Foundation

struct RecipeFilter {

    var cookTimeRanges: [ClosedRange<Int>] = []
    var servingsRanges: [ClosedRange<Int>] = []
    var minRatings: [Double] = []
    var cuisines: [String] = []
    var calorieRanges: [ClosedRange<Int>] = []

    static var empty: RecipeFilter {
        RecipeFilter()
    }
}

