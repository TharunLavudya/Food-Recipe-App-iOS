import SwiftUI
struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var selectedSegment = 0
    @State private var recipeCount = 0
    @State private var showOptionsMenu = false  // Toggles the visibility of the options (ellipsis) menu
    @ObservedObject var authViewModel : AuthViewModel
    @State private var showEditProfile = false


    var body: some View {
        ZStack(alignment: .topTrailing) {
            NavigationStack {
                VStack(alignment: .leading, spacing: 16) {
                    VStack {
                        profileHeader
                        segmentSection
                    }

                    ScrollView {
                        if selectedSegment == 0 {
                            recipeList
                        } else {
                            interestsList
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    .id(selectedSegment)
                }
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            withAnimation {
                                showOptionsMenu.toggle()
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .rotationEffect(.degrees(90))
                                .padding(8)
                        }
                    }
                }
            }
            // Floating options menu shown when ellipsis is tapped
            if showOptionsMenu {
                VStack(alignment: .leading, spacing: 16) {
                    Button {
                        showEditProfile = true
                        withAnimation {
                            showOptionsMenu = false
                        }
                    } label: {
                        Label("Edit Details", systemImage: "pencil")
                    }

                    Button {
                        authViewModel.signOut()
                    } label: {
                        Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                .frame(width: 180)
                .padding(.top, 50)
                .padding(.trailing, 10)
                .contentShape(Rectangle())
                .transition(.scale.combined(with: .opacity))
                .zIndex(10)
            }
        }
        .contentShape(Rectangle())
        // Dismiss options menu when tapping outside of it
        .onTapGesture {
            if showOptionsMenu {
                withAnimation {
                    showOptionsMenu = false
                }
            }
            
        }
        .sheet(isPresented: $showEditProfile) {
            EditProfileView(authViewModel: authViewModel)
        }
    }
    private var profileHeader: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 20) {
                Image("female")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(authViewModel.username)
                        .font(.headline)
                        .padding(.bottom, 5)
                        .padding(.top,10)

//                    Text("Private Chef \nPassionate about food info ")
                    Text(authViewModel.bio)
                        .font(.subheadline)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 120)
            Text("Total recipes posted: \(recipeCount)")
        }
        .padding(.horizontal, 20)
    }
    
    
    private var segmentSection: some View {
        HStack(spacing: 16) {
            Button {
                selectedSegment = 0
            } label: {
                Text("Recipes")
                    .fontWeight(selectedSegment == 0 ? .bold : .regular)
                    .foregroundColor(selectedSegment == 0 ? .white : .green)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(selectedSegment == 0 ? Color.green : Color.clear)
                    .cornerRadius(10)
            }

            Button {
                withAnimation {
                    selectedSegment = 1
                }
            } label: {
                Text("Interests")
                    .fontWeight(selectedSegment == 1 ? .bold : .regular)
                    .foregroundColor(selectedSegment == 1 ? .white : .green)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(selectedSegment == 1 ? Color.green : Color.clear)
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal)
    }
    // List of recipes posted by the user (Static for now)
    private var recipeList: some View {
        VStack(spacing: 16) {
            recipeCard(
                title: "Traditional spare ribs baked",
                duration: "20 min"
            )

            recipeCard(
                title: "Jollof roasted chicken with flavored rice",
                duration: "20 min"
            )
        }
    }
    //reusabale recipe card view used in recipelist
    private func recipeCard(title: String, duration: String) -> some View {
        ZStack(alignment: .bottomLeading) {
            Image("bg")
                .resizable()
                .scaledToFill()
                .frame(height: 150)
                .clipped()
                .cornerRadius(16)

            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)

                Text(duration)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding()
        }
        .background(
            LinearGradient(
                colors: [.black.opacity(0.9), .clear],
                startPoint: .bottom,
                endPoint: .top
            )
        )
        .cornerRadius(16)
    }

    private var interestsList: some View {
        VStack(alignment: .leading, spacing: 16) {
            if !viewModel.selectedCuisines.isEmpty {
                ForEach(viewModel.selectedCuisines) { cuisine in
                    HStack {
                        Text(cuisine.name)
                            .font(.body)
                        Spacer()
                        Button {
                            withAnimation {
                                viewModel.toggleCuisine(cuisine)
                            }
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 25))
                        }
                        .foregroundColor(.green)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(18)
                }
            }
            Button {
                viewModel.isShowingCuisinePicker = true
            } label: {
                Label {
                    Text("Add Interests")
                } icon: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 25))
                }
                .font(.subheadline.weight(.medium))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(.green.opacity(0.15))
                .foregroundColor(.green)
                .clipShape(Capsule())
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .sheet(isPresented: $viewModel.isShowingCuisinePicker) {
            CuisinePickerView(viewModel: viewModel)
        }
    }
}

#Preview {
    ProfileView(authViewModel: AuthViewModel())
}

