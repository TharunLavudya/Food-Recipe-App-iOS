
import SwiftUI
import Combine

class SplashViewModel: ObservableObject {
    @Published var isActive: Bool = false

    init() {
        startSplash()
    }

    private func startSplash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isActive = true
        }
    }
}
