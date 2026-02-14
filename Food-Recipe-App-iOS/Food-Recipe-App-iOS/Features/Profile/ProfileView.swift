import SwiftUI
struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var selectedSegment = 0
    @State private var recipeCount = 0
    @State private var showOptionsMenu = false  // Toggles the visibility of the options (ellipsis) menu
    @State private var showEditProfile = false
    @State private var selectedRecipeForEdit: Recipe?
    @ObservedObject var authViewModel : AuthViewModel

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
                .navigationDestination(item: $selectedRecipeForEdit) { recipe in
                    EditRecipeView(
                        viewModel: EditRecipeViewModel(recipe: recipe),
                        onUpdate: {
                            Task {
                                await viewModel.load()
                            }
                        }
                    )
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
        .task {
            await viewModel.load()
        }
        .sheet(isPresented: $showEditProfile)
        {
            EditProfileView(authViewModel: authViewModel)
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
    }
    private var profileHeader: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 20) {
            
                Image(profileImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(authViewModel.username)
                        .font(.headline)
                        .padding(.bottom, 5)
                        .padding(.top,10)

                    Text(authViewModel.bio)
                        .font(.subheadline)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 120)
            Text("Total recipes posted: \(viewModel.recipes.count)")
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

            if viewModel.recipes.isEmpty {

                Text("No recipes added yet")
                    .font(.subheadline.weight(.medium))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(.green.opacity(0.15))
                    .foregroundColor(.green)
                    .frame(maxWidth: .infinity,alignment: .center)

            } else {
                ForEach(viewModel.recipes) { recipe in
                    NavigationLink {
                        RecipeDetailView(
                            recipe: recipe,
                            allRecipes: viewModel.recipes
                        )
                    }label: {
                        recipeCard(
                            recipe : recipe,
                            onDelete: {
                                Task {
                                    await viewModel.deleteRecipe(recipe)
                                }
                            },onEdit: {
                                    selectedRecipeForEdit = recipe
                                }
                            )
                        }
                    }
                }

            }
    }
    //reusabale recipe card view used in recipelist
    private func recipeCard(recipe: Recipe ,onDelete: @escaping () -> Void, onEdit: @escaping () -> Void ) -> some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: recipe.image)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Image("bg") // shown while loading
                    .resizable()
                    .scaledToFill()
            }
            .frame(height: 150)
            .clipped()
            .cornerRadius(16)
            LinearGradient(
                colors: [.black.opacity(0.9), .clear],
                startPoint: .bottom,
                endPoint: .top
            )

            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(.headline)
                    .foregroundColor(.white)

                Text("\(recipe.cookTimeMinutes) min ")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding()
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button{
                        onEdit()
                    } label: {
                        Image(systemName: "pencil")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                    Button {
                        onDelete()
                    } label: {
                        Image(systemName: "trash.fill")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.red)
                            .clipShape(Circle())
                    }
                    .padding(10)
                }
            }

        }
//        .background(
//            LinearGradient(
//                colors: [.black.opacity(0.9), .clear],
//                
//                startPoint: .bottom,
//                endPoint: .top
//            )
//        )
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
    private var profileImage: String {
        switch authViewModel.gender {
        case "Male":
            return "male"
        case "Female":
            return "female"
        default:
            return "default"
        }
    }

}

