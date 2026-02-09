import Foundation
import SwiftUI
import Combine

@MainActor
final class AuthViewModel: Combine.ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isAuthenticated: Bool = false
    
    private let authService: AuthService
    
    init(authService: AuthService = FirebaseAuthService()) {
        self.authService = authService
        self.isAuthenticated = authService.getCurrentUserId() != nil
    }
    
    func signIn() async {
        isLoading = true
        errorMessage = nil
        do {
            try await authService.signIn(email: email, password: password)
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func signUp() async {
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }
        
        isLoading = true
        errorMessage = nil
        do {
            try await authService.signUp(email: email, password: password)
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func signOut() {
        do {
            try authService.signOut()
            isAuthenticated = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    func sendPasswordReset(email: String) async throws {
        try await authService.sendPasswordReset(email: email)
    }

}
