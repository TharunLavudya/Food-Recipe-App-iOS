import SwiftUI

struct SplashView: View {
    @State private var showLogin = false

    var body: some View {
        VStack {
            Text("Food Recipe App")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Loading...")
                .foregroundColor(.gray)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                showLogin = true
            }
        }
        .fullScreenCover(isPresented: $showLogin) {
            NavigationStack {
                LoginView(viewModel: AuthViewModel())
            }
        }
    }
}
