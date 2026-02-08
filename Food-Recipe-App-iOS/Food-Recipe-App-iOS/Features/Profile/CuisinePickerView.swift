//
//  CuisinePickerView.swift
//  Food-Recipe-App-iOS
//
//  Created by rentamac on 2/8/26.
//

import SwiftUI

struct CuisinePickerView: View {

    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    VStack(spacing: 12) {
                        ProgressView()
                        Text("Loading cuisines...")
                            .foregroundColor(.gray)
                    }
                } else {
                    List {
                        ForEach(viewModel.allCuisines) { cuisine in
                            HStack {
                                Text(cuisine.name)
                                    .foregroundColor(.primary)

                                Spacer()

                                if viewModel.selectedCuisines.contains(cuisine) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                }
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
                                        viewModel.selectedCuisines.contains(cuisine)
                                        ? Color.green.opacity(0.12)
                                        : Color.clear
                                    )
                            )
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    viewModel.toggleCuisine(cuisine)
                                }
                            }
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Select Interests")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .fontWeight(.semibold)
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .task {
            await viewModel.fetchCuisines()
        }
    }
}
