//
//  EditRecipeView.swift
//  Food-Recipe-App-iOS
//
//  Created by rentamac on 2/13/26.
//

import SwiftUI

struct EditRecipeView: View {

    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: EditRecipeViewModel
    @EnvironmentObject var homeVM: HomeViewModel

    var onUpdate: () -> Void
    
    private var uniqueCuisines: [String] {
        Array(Set(homeVM.recipes.map { $0.cuisine })).sorted()
    }


    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 16) {
                Text("Recipe Name").bold()
                styledField("Recipe Name", $viewModel.name)
                Text("Cuisine").bold()
//                styledField("Cuisine", $viewModel.cuisine)
                HStack {
//                    Text("Cuisine")
//                        .bold()
//                    Spacer()
                    Picker("", selection: $viewModel.cuisine) {
                        Text("Select")
                            .tag("")
                        ForEach(uniqueCuisines, id: \.self) { cuisine in
                            Text(cuisine)
                                .tag(cuisine)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)

                Text("Cook Time").bold()
                styledField("Cook Time (mins)", $viewModel.cookTime)
                Text("Image URL").bold()
                styledField("Image URL", $viewModel.imageURL)


                if let url = URL(string: viewModel.imageURL),
                   !viewModel.imageURL.isEmpty {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 180)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .cornerRadius(12)
                }

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Ingredients")
                            .bold()
                        Spacer()
                        Button("+ Add") {
                            viewModel.addIngredient()
                        }
                        .font(.caption)
                    }

                    ForEach(viewModel.ingredients.indices, id: \.self) { index in
                        HStack {
                            TextField(
                                "Ingredient \(index + 1)",
                                text: $viewModel.ingredients[index]
                            )
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            
                            Button {
                                viewModel.removeIngredient(at: index)
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Instructions")
                            .bold()
                        Spacer()
                        Button("+ Add") {
                            viewModel.addInstruction()
                        }
                        .font(.caption)
                    }

                    ForEach(viewModel.instructions.indices, id: \.self) { index in
                        HStack(alignment: .top) {
                            TextField(
                                "Step \(index + 1)",
                                text: $viewModel.instructions[index],
                                axis: .vertical
                            )
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)

                            Button {
                                viewModel.removeInstruction(at: index)
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }

                Button {
                    Task {
                        try await viewModel.updateRecipe()
                        onUpdate()
                        dismiss()
                    }
                } label: {
                    Text("Update Recipe")
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        
                }
                .padding(.top, 10)
            }
            .padding()
        }
        .navigationTitle("Edit Recipe")
    }
    private func styledField(_ title: String, _ binding: Binding<String> ) -> some View {
        TextField(title, text: binding)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
    }
}
