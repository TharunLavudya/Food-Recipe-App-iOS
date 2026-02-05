

import SwiftUI

struct AppRouter: View {
    var body: some View {
        MainTabView()
    }
}


struct MainTabView: View {

    let environment = AppEnvironment.shared

    var body: some View {
        TabView {

            HomeView(repository: environment.recipeRepository)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            FavouriteView()
                .tabItem {
                    Image(systemName: "bookmark.fill")
                    Text("Favorites")
                }

            AddRecipeView()
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Add")
                }

            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .tint(.green)
    }
}
