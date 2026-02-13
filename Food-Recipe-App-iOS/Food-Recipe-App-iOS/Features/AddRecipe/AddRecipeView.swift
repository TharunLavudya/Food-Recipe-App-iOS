import SwiftUI

struct AddRecipeView: View {

    @StateObject private var viewModel =
        AddRecipeViewModel()
    @EnvironmentObject var homeVM: HomeViewModel
    let difficulties = ["Easy", "Medium", "Hard"]

    var body: some View {

        ScrollView {

            VStack(spacing: 20) {

                header

                basicInfoSection
                
                cuisineSection

                difficultySection

                ingredientsSection

                instructionsSection
                
                if let error = viewModel.errorMessage {

                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                            .padding(.horizontal, 4)
                    }

                submitButton
            }
            .padding()
        }
        .alert(
            "Success",
            isPresented: $viewModel.showSuccessPopup
        ) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.successMessage ?? "")
        }
        .navigationTitle("Add Recipe")
    }
}
extension AddRecipeView {
    
    private var header: some View {

        VStack(spacing: 6) {

            Image(systemName: "fork.knife.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(.green)

            Text("Create New Recipe")
                .font(.title2)
                .bold()
        }
    }
    private var basicInfoSection: some View {

        VStack(spacing: 12) {

            textField("Recipe Name", $viewModel.name)
            textField("Cook Time (mins)", $viewModel.cookTime)
            
            VStack(alignment: .leading, spacing: 8) {

                TextField(
                    "Image URL",
                    text: $viewModel.imageURL
                )
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                if let url =
                    URL(string: viewModel.imageURL),
                   !viewModel.imageURL.isEmpty {

                    AsyncImage(url: url) { phase in

                        switch phase {

                        case .empty:
                            ProgressView()
                                .frame(height: 180)

                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()

                        case .failure:
                            previewPlaceholder

                        @unknown default:
                            EmptyView()
                        }

                    }
                    .frame(height: 180)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray5))
                    .cornerRadius(16)
                }
            }

        }
    }
    private var previewPlaceholder: some View {

        VStack {

            Image(systemName: "photo")
                .font(.largeTitle)
                .foregroundColor(.gray)

            Text("Image preview unavailable")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 180)
    }

    private func textField(
        _ title: String,
        _ binding: Binding<String>
    ) -> some View {

        TextField(title, text: binding)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
    }
    private var cuisineSection: some View {

        HStack {
            
            Text("Cuisine")
                .bold()

            Spacer()

            Picker(
                "",
                selection: $viewModel.cuisine
            ) {

                Text("Select")
                    .tag("")

                ForEach(
                    uniqueCuisines,
                    id: \.self
                ) { cuisine in
                    Text(cuisine)
                        .tag(cuisine)
                }
            }
            .pickerStyle(.menu)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private var uniqueCuisines: [String] {

        Array(
            Set(
                homeVM.recipes.map { $0.cuisine }
            )
        ).sorted()
    }
    private var difficultySection: some View {

        VStack(alignment: .leading, spacing: 10) {

            Text("Difficulty")
                .bold()

            HStack(spacing: 12) {

                ForEach(difficulties, id: \.self) { level in

                    Text(level)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            viewModel.difficulty == level
                            ? Color.green
                            : Color(.systemGray5)
                        )
                        .foregroundColor(
                            viewModel.difficulty == level
                            ? .white : .primary
                        )
                        .cornerRadius(12)
                        .onTapGesture {
                            viewModel.difficulty = level
                        }
                }
            }
        }
    }


    private var ingredientsSection: some View {

        VStack(alignment: .leading, spacing: 12) {

            HStack {
                Text("Ingredients")
                    .bold()

                Spacer()

                Button("+ Add") {
                    viewModel.addIngredient()
                }
                .font(.caption)
            }

            ForEach(
                viewModel.ingredients.indices,
                id: \.self
            ) { index in

                HStack {

                    TextField(
                        "Ingredient \(index + 1)",
                        text: $viewModel.ingredients[index]
                    )
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                    Button {
                        viewModel.removeIngredient(at: index)
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
    private var instructionsSection: some View {

        VStack(alignment: .leading, spacing: 12) {

            HStack {
                Text("Instructions")
                    .bold()

                Spacer()

                Button("+ Add") {
                    viewModel.addInstruction()
                }
                .font(.caption)
            }

            ForEach(
                viewModel.instructions.indices,
                id: \.self
            ) { index in

                HStack(alignment: .top) {

                    TextField(
                        "Step \(index + 1)",
                        text: $viewModel.instructions[index],
                        axis: .vertical
                    )
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                    Button {
                        viewModel.removeInstruction(at: index)
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
    private var submitButton: some View {
        
        Button {

            Task {
                await viewModel.submitRecipe()
            }

        } label: {

            if viewModel.isLoading {

                ProgressView()

            } else {

                Text("Publish Recipe")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(14)
            }
        }
    }
}
