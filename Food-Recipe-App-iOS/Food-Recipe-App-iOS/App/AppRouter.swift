import SwiftUI

struct AppRouter: View {

    @StateObject private var authViewModel = AuthViewModel()
    @State private var showSplash = true

    var body: some View {

        Group {

            if showSplash {

                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            showSplash = false
                        }
                    }

            } else if authViewModel.isAuthenticated {

                MainTabView(authViewModel: authViewModel)

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

            FavouriteView()
                .tabItem {
                    Image(systemName: "bookmark.fill")
                    Text("Favorites")
                }
                .tag(2)

            AddRecipeView()
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Add")
                }
                .tag(3)

            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(4)
        }
        .tint(.green)
    }
}

