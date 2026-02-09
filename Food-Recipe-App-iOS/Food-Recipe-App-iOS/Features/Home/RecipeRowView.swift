

import SwiftUI

struct RecipeRowView: View {

    let recipe: Recipe

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: recipe.image)) { image in
                image.resizable()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 160, height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Text(recipe.name)
                .font(.headline)
                .lineLimit(1)

            HStack {
                Text("⭐️ \(String(format: "%.1f", recipe.rating))")
                Spacer()
                Text("\(recipe.cookTimeMinutes) mins")
                    .foregroundColor(.secondary)
            }
            .font(.caption)
        }
        .frame(width: 160)
    }
}
