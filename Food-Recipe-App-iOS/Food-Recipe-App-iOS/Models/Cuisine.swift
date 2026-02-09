//
//  Cuisine.swift
//  Food-Recipe-App-iOS
//
//  Created by rentamac on 2/8/26.
//


import Foundation
import Combine

struct Cuisine: Identifiable, Hashable {
    let id = UUID()
    let name: String
}