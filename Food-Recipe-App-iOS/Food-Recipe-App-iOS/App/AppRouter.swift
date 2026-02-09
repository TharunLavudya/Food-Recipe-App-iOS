

import SwiftUI

struct AppRouter: View {
    var body: some View {
        MainTabView()
    }
}


struct MainTabView: View {

    let environment = AppEnvironment.shared
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {

            HomeView(
                repository: environment.recipeRepository,
                selectedTab: $selectedTab
            )
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)

            FavouriteView()
                .tabItem {
                    Image(systemName: "bookmark.fill")
                    Text("Favorites")
                }
                .tag(1)

            AddRecipeView()
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Add")
                }
                .tag(2)

            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(3)
        }
        .tint(.green)
    }
}
