struct EditRecipeView: View {

    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: EditRecipeViewModel

    var onUpdate: () -> Void

    var body: some View {

        ScrollView {

            VStack(spacing: 16) {

                TextField("Recipe Name", text: $viewModel.name)
                TextField("Cuisine", text: $viewModel.cuisine)
                TextField("Cook Time", text: $viewModel.cookTime)
                TextField("Image URL", text: $viewModel.imageURL)

                Button("Update Recipe") {
                    Task {
                        try await viewModel.updateRecipe()
                        onUpdate()
                        dismiss()
                    }
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("Edit Recipe")
    }
}
