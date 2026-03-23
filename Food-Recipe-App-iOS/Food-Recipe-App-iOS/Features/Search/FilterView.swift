import SwiftUI

struct FilterView: View {

    @Environment(\.dismiss) private var dismiss
    @Binding var filter: RecipeFilter
    let cuisineOptions: [String]

    @State private var selectedCookTimes: Set<String> = []
    @State private var selectedRatings: Set<String> = []
    @State private var selectedCuisines: Set<String> = []
    @State private var selectedMealTypes: Set<String> = []
    @State private var selectedDifficulties: Set<String> = []

//    let cookTimeOptions = [
//        "0-5": 0...5,
//        "5-10": 5...10,
//        "10-15": 10...15,
//        "15-30": 15...30
//    ]
    
    private let cookTimeOrder = ["0-10", "10-20", "20-30+"]
        private let cookTimeOptions: [String: ClosedRange<Int>] = [
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
        VStack(spacing: 24) {
            Text("Filter Recipes")
                .font(.largeTitle)
                .bold()
                .padding(.top, 20)

            ScrollView {
                VStack(spacing: 24) {
                    
                    
                    multiSelectChips(title: "Meal Type", options: mealTypeOptions, selected: $selectedMealTypes)
                    multiSelectChips(title: "Difficulty", options: difficultyOptions, selected: $selectedDifficulties)
                    multiSelectChips(title: "Cooking Time", options: cookTimeOrder, selected: $selectedCookTimes)
                    multiSelectChips(title: "Rating", options: Array(ratingOptions.keys), selected: $selectedRatings)
                    multiSelectChips(title: "Cuisine", options: cuisineOptions, selected: $selectedCuisines)
                    
                }
                .padding(.horizontal)
            }

            HStack(spacing: 16) {
                Button("Reset") { resetFilters() }
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
            selectedCookTimes = Set(filter.cookTimeRanges.compactMap { range in
                cookTimeOptions.first(where: { $0.value == range })?.key
            })
            selectedRatings = Set(filter.minRatings.compactMap { rating in
                ratingOptions.first(where: { $0.value == rating })?.key
            })
            selectedCuisines = Set(filter.cuisines)
            selectedMealTypes = Set(filter.mealTypes)
            selectedDifficulties = Set(filter.difficultyLevels)
        }
    }

    private func multiSelectChips(title: String, options: [String], selected: Binding<Set<String>>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.headline)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 90), spacing: 8)], spacing: 8) {
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
        filter.minRatings = selectedRatings.compactMap { ratingOptions[$0] }
        filter.cuisines = Array(selectedCuisines)
        filter.mealTypes = Array(selectedMealTypes)
        filter.difficultyLevels = Array(selectedDifficulties)
    }

    private func resetFilters() {
        filter = .empty
        selectedCookTimes.removeAll()
        selectedRatings.removeAll()
        selectedCuisines.removeAll()
        selectedMealTypes.removeAll()
        selectedDifficulties.removeAll()
    }
}
