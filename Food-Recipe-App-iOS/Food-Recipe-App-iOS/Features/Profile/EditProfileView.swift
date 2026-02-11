//
//  EditProfileView.swift
//  Food-Recipe-App-iOS
//
//  Created by rentamac on 2/11/26.
//


import SwiftUI

struct EditProfileView: View {
    
    @ObservedObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var editedUsername: String = ""
    @State private var editedBio: String = ""
    @State private var isSaving = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                // Username
                VStack(alignment: .leading) {
                    Text("Username")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    TextField("Enter username", text: $editedUsername)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
                
                // Bio
                VStack(alignment: .leading) {
                    Text("Bio")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    TextField("Enter bio", text: $editedBio, axis: .vertical)
                        .lineLimit(3...6)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
                
                Spacer()
                
                // Save Button
                Button {
                    saveProfile()
                } label: {
                    if isSaving {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text("Save Changes")
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(12)
                .disabled(isSaving || editedUsername.isEmpty)
            }
            .padding()
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                editedUsername = authViewModel.username
                editedBio = authViewModel.bio
            }
        }
    }
    
    private func saveProfile() {
        Task {
            await authViewModel.updateProfile(
                newUsername: editedUsername,
                newBio: editedBio
            )
            dismiss()
        }
    }
}
