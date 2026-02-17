//
//
//import SwiftUI
//
//struct SortFilterView: View {
//
//    @Environment(\.dismiss) private var dismiss
//    @Binding var filter: RecipeFilter
//
//    @State private var selectedCookTimes: Set<String> = []
//    @State private var selectedRatings: Set<String> = []
//    @State private var selectedServings: Set<String> = []
//    @State private var selectedCuisines: Set<String> = []
//    @State private var selectedCalories: Set<String> = []
//
//    let cookTimeOptions = [
//        "0-5": 0...5,
//        "5-10": 5...10,
//        "10-15": 10...15,
//        "15-30": 15...30
//    ]
//
//    let servingsOptions = [
//        "1-2": 1...2,
//        "3-4": 3...4,
//        "5+": 5...20
//    ]
//
//    let ratingOptions = [
//        "3+": 3.0,
//        "4+": 4.0,
//        "4.5+": 4.5
//    ]
//
//    let calorieOptions = [
//        "0-200": 0...200,
//        "200-400": 200...400,
//        "400+": 400...2000
//    ]
//
//    // Hardcoded cuisines (you can pass dynamically later)
//    let cuisineOptions = [
//        "Italian", "Indian", "Mexican", "Chinese", "American"
//    ]
//
//    var body: some View {
//
//        NavigationStack {
//            Form {
//
//                multiSelectSection(
//                    title: "Cooking Time",
//                    options: Array(cookTimeOptions.keys),
//                    selected: $selectedCookTimes
//                )
//
//                multiSelectSection(
//                    title: "Servings",
//                    options: Array(servingsOptions.keys),
//                    selected: $selectedServings
//                )
//
//                multiSelectSection(
//                    title: "Rating",
//                    options: Array(ratingOptions.keys),
//                    selected: $selectedRatings
//                )
//
//                multiSelectSection(
//                    title: "Calories",
//                    options: Array(calorieOptions.keys),
//                    selected: $selectedCalories
//                )
//
//                multiSelectSection(
//                    title: "Cuisine",
//                    options: cuisineOptions,
//                    selected: $selectedCuisines
//                )
//            }
//            .navigationTitle("Filters")
//            .toolbar {
//
//                ToolbarItem(placement: .topBarLeading) {
//                    Button("Reset") {
//                        filter = .empty
//                        dismiss()
//                    }
//                }
//
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button("Apply") {
//                        applyFilters()
//                        dismiss()
//                    }
//                }
//            }
//        }
//    }
//
//    private func multiSelectSection(
//        title: String,
//        options: [String],
//        selected: Binding<Set<String>>
//    ) -> some View {
//
//        Section(title) {
//            ForEach(options, id: \.self) { option in
//                Button {
//                    if selected.wrappedValue.contains(option) {
//                        selected.wrappedValue.remove(option)
//                    } else {
//                        selected.wrappedValue.insert(option)
//                    }
//                } label: {
//                    HStack {
//                        Text(option)
//                        Spacer()
//                        if selected.wrappedValue.contains(option) {
//                            Image(systemName: "checkmark")
//                                .foregroundColor(.green)
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    private func applyFilters() {
//
//        filter.cookTimeRanges = selectedCookTimes.compactMap { cookTimeOptions[$0] }
//        filter.servingsRanges = selectedServings.compactMap { servingsOptions[$0] }
//        filter.minRatings = selectedRatings.compactMap { ratingOptions[$0] }
//        filter.calorieRanges = selectedCalories.compactMap { calorieOptions[$0] }
//        filter.cuisines = Array(selectedCuisines)
//    }
//}
//
//import SwiftUI
//
//struct SortFilterView: View {
//
//    @Environment(\.dismiss) private var dismiss
//    @Binding var filter: RecipeFilter
//
//    @State private var selectedCookTimes: Set<String> = []
//    @State private var selectedRatings: Set<String> = []
//    @State private var selectedCuisines: Set<String> = []
//    @State private var selectedMealTypes: Set<String> = []
//    @State private var selectedDifficulties: Set<String> = []
//
//    let cookTimeOptions = [
//        "0-5": 0...5,
//        "5-10": 5...10,
//        "10-15": 10...15,
//        "15-30": 15...30
//    ]
//
//    let ratingOptions = [
//        "3+": 3.0,
//        "4+": 4.0,
//        "4.5+": 4.5
//    ]
//
//    let cuisineOptions = [
//        "Italian", "Indian", "Mexican", "Chinese", "American"
//    ]
//
//    let mealTypeOptions = [
//        "Breakfast", "Lunch", "Dinner", "Snack", "Dessert"
//    ]
//
//    let difficultyOptions = [
//        "Easy", "Medium", "Hard"
//    ]
//
//    var body: some View {
//
//        NavigationStack {
//            Form {
//
//                multiSelectSection(title: "Cooking Time", options: Array(cookTimeOptions.keys), selected: $selectedCookTimes)
//                multiSelectSection(title: "Rating", options: Array(ratingOptions.keys), selected: $selectedRatings)
//                multiSelectSection(title: "Cuisine", options: cuisineOptions, selected: $selectedCuisines)
//                multiSelectSection(title: "Meal Type", options: mealTypeOptions, selected: $selectedMealTypes)
//                multiSelectSection(title: "Difficulty", options: difficultyOptions, selected: $selectedDifficulties)
//
//            }
//            .navigationTitle("Filters")
//            .toolbar {
//
//                ToolbarItem(placement: .topBarLeading) {
//                    Button("Reset") {
//                        filter = .empty
//                        dismiss()
//                    }
//                }
//
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button("Apply") {
//                        applyFilters()
//                        dismiss()
//                    }
//                }
//            }
//        }
//    }
//
//    private func multiSelectSection(title: String, options: [String], selected: Binding<Set<String>>) -> some View {
//
//        Section(title) {
//            ForEach(options, id: \.self) { option in
//                Button {
//                    if selected.wrappedValue.contains(option) {
//                        selected.wrappedValue.remove(option)
//                    } else {
//                        selected.wrappedValue.insert(option)
//                    }
//                } label: {
//                    HStack {
//                        Text(option)
//                        Spacer()
//                        if selected.wrappedValue.contains(option) {
//                            Image(systemName: "checkmark")
//                                .foregroundColor(.green)
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    private func applyFilters() {
//        filter.cookTimeRanges = selectedCookTimes.compactMap { cookTimeOptions[$0] }
//        filter.minRatings = selectedRatings.compactMap { ratingOptions[$0] }
//        filter.cuisines = Array(selectedCuisines)
//        filter.mealTypes = Array(selectedMealTypes)
//        filter.difficultyLevels = Array(selectedDifficulties)
//    }
//}


import SwiftUI

struct SortFilterView: View {

    @Environment(\.dismiss) private var dismiss
    @Binding var filter: RecipeFilter
    let cuisineOptions: [String]

    @State private var selectedCookTimes: Set<String> = []
    @State private var selectedRatings: Set<String> = []
    @State private var selectedCuisines: Set<String> = []
    @State private var selectedMealTypes: Set<String> = []
    @State private var selectedDifficulties: Set<String> = []

    let cookTimeOrder = ["0-10", "10-20", "20-30+"]
    let cookTimeOptions: [String: ClosedRange<Int>] = [
        "0-10": 0...10,
        "10-20": 10...20,
        "20-30+": 20...1000
    ]

    let ratingOptions = [
        "3+": 3.0,
        "4+": 4.0,
        "4.5+": 4.5
    ]

    let mealTypeOptions = [
        "Breakfast", "Lunch", "Dinner", "Snack", "Dessert"
    ]

    let difficultyOptions = [
        "Easy", "Medium", "Hard"
    ]

    var body: some View {
        NavigationStack {
            Form {
                multiSelectSection(title: "Meal Type", options: mealTypeOptions, selected: $selectedMealTypes)
                multiSelectSection(title: "Difficulty", options: difficultyOptions, selected: $selectedDifficulties)
                multiSelectSection(title: "Cooking Time", options: cookTimeOrder, selected: $selectedCookTimes)
                multiSelectSection(title: "Rating", options: Array(ratingOptions.keys), selected: $selectedRatings)
                multiSelectSection(title: "Cuisine", options: cuisineOptions, selected: $selectedCuisines)
                
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
    
    private func horizontalChips(title: String, options: [String], selected: Binding<Set<String>>) -> some View {
          VStack(alignment: .leading, spacing: 8) {
              Text(title)
                  .font(.headline)

              ScrollView(.horizontal, showsIndicators: false) {
                  HStack(spacing: 8) {
                      ForEach(options, id: \.self) { option in
                          Button {
                              if selected.wrappedValue.contains(option) {
                                  selected.wrappedValue.remove(option)
                              } else {
                                  selected.wrappedValue.insert(option)
                              }
                          } label: {
                              Text(option)
                                  .padding(.horizontal, 12)
                                  .padding(.vertical, 8)
                                  .background(selected.wrappedValue.contains(option) ? Color.green : Color(.systemGray6))
                                  .foregroundColor(selected.wrappedValue.contains(option) ? .white : .primary)
                                  .cornerRadius(12)
                          }
                      }
                  }
                  .padding(.vertical, 4)
              }
          }
      }


    private func multiSelectSection(title: String, options: [String], selected: Binding<Set<String>>) -> some View {
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
        filter.minRatings = selectedRatings.compactMap { ratingOptions[$0] }
        filter.cuisines = Array(selectedCuisines)
        filter.mealTypes = Array(selectedMealTypes)
        filter.difficultyLevels = Array(selectedDifficulties)
    }
}
