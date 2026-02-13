import SwiftUI

struct AppRouter: View {

    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var favoritesVM =
            FavoritesViewModel(
                repo: FavoritesRepository()
            )
    @StateObject private var homeVM =
        HomeViewModel(
            repository: AppEnvironment.shared.recipeRepository
        )
    @State private var showSplash = true

    var body: some View {

        Group {

            if showSplash {

                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showSplash = false
                        }
                    }

            } else if authViewModel.isAuthenticated {

                MainTabView(
                    authViewModel: authViewModel
                )
                .environmentObject(favoritesVM)
                .environmentObject(homeVM)
                .task {
                    await homeVM.loadRecipes()
                }


            } else {

                NavigationStack {
                    LoginView(viewModel: authViewModel)
                }
            }
        }
    }
}



struct MainTabView: View {

    let environment = AppEnvironment.shared
    @State private var selectedTab = 0
    @ObservedObject var authViewModel: AuthViewModel
    @EnvironmentObject var favoritesVM: FavoritesViewModel
    
    var body: some View {
        TabView(selection: $selectedTab) {

            HomeView(
                repository: environment.recipeRepository,
                selectedTab: $selectedTab,
                authViewModel: authViewModel
            )
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            
            SearchView(
                repository: environment.recipeRepository,
                selectedTab: $selectedTab
            )
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }
            .tag(1)

            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
                .tag(2)

            AddRecipeView()
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Add")
                }
                .tag(3)

            ProfileView(authViewModel: authViewModel)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(4)
        }
        .tint(.green)
    }
}

