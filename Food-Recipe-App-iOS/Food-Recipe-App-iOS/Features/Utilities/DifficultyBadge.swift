//
//  DifficultyBadge.swift
//  Food-Recipe-App-iOS
//
//  Created by rentamac on 3/9/26.
//

import SwiftUI

struct DifficultyBadge: View {

    let difficulty: String

    var color: Color {
        switch difficulty.lowercased() {
        case "easy":
            return .green
        case "medium":
            return .orange
        case "hard":
            return .red
        default:
            return .gray
        }
    }

    var body: some View {
        Text(difficulty.capitalized)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .cornerRadius(8)
    }
}
