//
//  FilterView.swift
//  Food-Recipe-App-iOS
//
//  Created by rentamac on 2/12/26.
//

import SwiftUI

struct FilterView: View {

    @Environment(\.dismiss) private var dismiss
    @Binding var filter: RecipeFilter

    @State private var selectedCookTimes: Set<String> = []
    @State private var selectedRatings: Set<String> = []
    @State private var selectedServings: Set<String> = []
    @State private var selectedCuisines: Set<String> = []
    @State private var selectedCalories: Set<String> = []

    let cookTimeOptions = [
        "0-5": 0...5,
        "5-10": 5...10,
        "10-15": 10...15,
        "15-30": 15...30
    ]

    let servingsOptions = [
        "1-2": 1...2,
        "3-4": 3...4,
        "5+": 5...20
    ]

    let ratingOptions = [
        "3+": 3.0,
        "4+": 4.0,
        "4.5+": 4.5
    ]

    let calorieOptions = [
        "0-200": 0...200,
        "200-400": 200...400,
        "400+": 400...2000
    ]

    let cuisineOptions = [
        "Italian", "Indian", "Mexican", "Chinese", "American"
    ]

    var body: some View {
        VStack(spacing: 24) {

            Text("Filters")
                .font(.largeTitle)
                .bold()
                .padding(.top, 20)

            ScrollView {
                VStack(spacing: 24) {

                    multiSelectChips(title: "Cooking Time",
                                     options: Array(cookTimeOptions.keys),
                                     selected: $selectedCookTimes)

                    multiSelectChips(title: "Servings",
                                     options: Array(servingsOptions.keys),
                                     selected: $selectedServings)

                    multiSelectChips(title: "Rating",
                                     options: Array(ratingOptions.keys),
                                     selected: $selectedRatings)

                    multiSelectChips(title: "Calories",
                                     options: Array(calorieOptions.keys),
                                     selected: $selectedCalories)

                    multiSelectChips(title: "Cuisine",
                                     options: cuisineOptions,
                                     selected: $selectedCuisines)
                }
                .padding(.horizontal)
            }

            HStack(spacing: 16) {
                Button("Reset") {
                    resetFilters()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)

                Button("Apply") {
                    applyFilters()
                    dismiss()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding()
        }
        .onAppear {
            // Load current filter selections
            selectedCookTimes = Set(filter.cookTimeRanges.compactMap { range in
                cookTimeOptions.first { $0.value == range }?.key
            })
            selectedServings = Set(filter.servingsRanges.compactMap { range in
                servingsOptions.first { $0.value == range }?.key
            })
            selectedRatings = Set(filter.minRatings.compactMap { rating in
                ratingOptions.first { $0.value == rating }?.key
            })
            selectedCalories = Set(filter.calorieRanges.compactMap { range in
                calorieOptions.first { $0.value == range }?.key
            })
            selectedCuisines = Set(filter.cuisines)
        }
    }

    private func multiSelectChips(title: String, options: [String], selected: Binding<Set<String>>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 8)], spacing: 8) {
                ForEach(options, id: \.self) { option in
                    Button {
                        if selected.wrappedValue.contains(option) {
                            selected.wrappedValue.remove(option)
                        } else {
                            selected.wrappedValue.insert(option)
                        }
                    } label: {
                        Text(option)
                            .padding(8)
                            .frame(maxWidth: .infinity)
                            .background(selected.wrappedValue.contains(option) ? Color.green : Color(.systemGray6))
                            .foregroundColor(selected.wrappedValue.contains(option) ? .white : .primary)
                            .cornerRadius(12)
                    }
                }
            }
        }
    }

    private func applyFilters() {
        filter.cookTimeRanges = selectedCookTimes.compactMap { cookTimeOptions[$0] }
        filter.servingsRanges = selectedServings.compactMap { servingsOptions[$0] }
        filter.minRatings = selectedRatings.compactMap { ratingOptions[$0] }
        filter.calorieRanges = selectedCalories.compactMap { calorieOptions[$0] }
        filter.cuisines = Array(selectedCuisines)
    }

    private func resetFilters() {
        filter = .empty
        selectedCookTimes.removeAll()
        selectedServings.removeAll()
        selectedRatings.removeAll()
        selectedCalories.removeAll()
        selectedCuisines.removeAll()
    }
}
