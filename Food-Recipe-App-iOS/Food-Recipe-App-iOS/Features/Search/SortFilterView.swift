

import SwiftUI

struct SortFilterView: View {

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

    // Hardcoded cuisines (you can pass dynamically later)
    let cuisineOptions = [
        "Italian", "Indian", "Mexican", "Chinese", "American"
    ]

    var body: some View {

        NavigationStack {
            Form {

                multiSelectSection(
                    title: "Cooking Time",
                    options: Array(cookTimeOptions.keys),
                    selected: $selectedCookTimes
                )

                multiSelectSection(
                    title: "Servings",
                    options: Array(servingsOptions.keys),
                    selected: $selectedServings
                )

                multiSelectSection(
                    title: "Rating",
                    options: Array(ratingOptions.keys),
                    selected: $selectedRatings
                )

                multiSelectSection(
                    title: "Calories",
                    options: Array(calorieOptions.keys),
                    selected: $selectedCalories
                )

                multiSelectSection(
                    title: "Cuisine",
                    options: cuisineOptions,
                    selected: $selectedCuisines
                )
            }
            .navigationTitle("Filters")
            .toolbar {

                ToolbarItem(placement: .topBarLeading) {
                    Button("Reset") {
                        filter = .empty
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Apply") {
                        applyFilters()
                        dismiss()
                    }
                }
            }
        }
    }

    private func multiSelectSection(
        title: String,
        options: [String],
        selected: Binding<Set<String>>
    ) -> some View {

        Section(title) {
            ForEach(options, id: \.self) { option in
                Button {
                    if selected.wrappedValue.contains(option) {
                        selected.wrappedValue.remove(option)
                    } else {
                        selected.wrappedValue.insert(option)
                    }
                } label: {
                    HStack {
                        Text(option)
                        Spacer()
                        if selected.wrappedValue.contains(option) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                        }
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
}
