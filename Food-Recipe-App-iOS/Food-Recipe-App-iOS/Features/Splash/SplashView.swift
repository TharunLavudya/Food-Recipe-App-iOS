import SwiftUI

struct SplashView: View {
    @State private var animate = false
    @State private var navigateToLogin = false

    var body: some View {
        NavigationStack {
            ZStack {
                
                Image("Splash_bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .overlay(
                        Color.black.opacity(0.45)
                    )

                VStack(spacing: 24) {

                    Spacer()

                    
                    VStack(spacing: 10) {
                        Text("Get")
                            .font(.system(size: 42, weight: .bold))
                            .foregroundColor(.white)

                        Text("Cooking")
                            .font(.system(size: 42, weight: .bold))
                            .foregroundColor(.white)

                        Text("Simple way to find Tasty Recipe")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .offset(y: animate ? 0 : 30)
                    .opacity(animate ? 1 : 0)

                    Spacer()

                    Button {
                        navigateToLogin = true
                    } label: {
                        HStack {
                            Text("Start Cooking")
                                .fontWeight(.semibold)

                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 14)
                        .background(Color.green)
                        .cornerRadius(14)
                    }
                    .opacity(animate ? 1 : 0)
                    .scaleEffect(animate ? 1 : 0.9)

                    Spacer(minLength: 40)
                }
            }
            .onAppear {
                withAnimation(.easeOut(duration: 1.2)) {
                    animate = true
                }
            }
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginView()
            }
        }
    }
}

