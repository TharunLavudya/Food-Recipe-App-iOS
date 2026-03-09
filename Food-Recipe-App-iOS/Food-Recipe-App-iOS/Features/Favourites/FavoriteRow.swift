//
//  FavoriteRow.swift
//  Food-Recipe-App-iOS
//
//  Created by rentamac on 2/11/26.
//

import SwiftUI

struct FavoriteRow: View {

    let recipe: Recipe

    var body: some View {

        HStack(spacing: 12) {

            AsyncImage(url: URL(string: recipe.image)) { phase in

                switch phase {

                case .empty:
                    ProgressView()
                        .frame(width: 80, height: 80)

                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()

                case .failure:
                    Image("AppLogo")
                        .resizable()
                        .scaledToFit()
                        .padding(20)
                        .foregroundColor(.gray)

                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 80, height: 80)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 6) {

                Text(recipe.name)
                    .font(.headline)

                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                HStack {

                    Label(
                        "\(recipe.rating, specifier: "%.1f")",
                        systemImage: "star.fill"
                    )
                    .font(.caption)
                    .foregroundColor(.orange)

                    Text("\(recipe.reviewCount) reviews")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}
