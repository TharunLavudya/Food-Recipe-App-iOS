import Foundation
import SwiftUI
import Combine
import FirebaseAuth

@MainActor
final class AuthViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isAuthenticated: Bool = false
    @Published var successMessage: String?
    
    @Published var username: String = ""
    @Published var signupUsername: String = ""
    @Published var bio: String = ""
    @Published var gender: String = ""

    
    private let authService: AuthService
    private let userService = UserService()
    
    init(authService: AuthService = FirebaseAuthService()) {
        self.authService = authService
        self.isAuthenticated = authService.getCurrentUserId() != nil
        if isAuthenticated {
                Task {
                    await fetchUserProfile()
                }
            }

    }
    func fetchUserProfile() async {
        do {
            let profile = try await userService.fetchUserProfile()
            self.username = profile.username
            self.bio = profile.bio
            self.gender = profile.gender
        } catch {
            print("Failed to fetch user profile:", error)
        }
    }
    func updateProfile(
        newUsername: String,
        newBio: String,
        newGender: String
    ) async {

        do {
            try await userService.updateUserProfile(
                username: newUsername,
                bio: newBio,
                gender: newGender
            )

            self.username = newUsername.capitalized
            self.bio = newBio
            self.gender = newGender

        } catch {
            errorMessage = "Profile update failed"
        }
    }

    
    // Validation Helpers
    
    private func isValidGmail(_ email: String) -> Bool {
        let pattern = #"^[A-Z0-9a-z._%+-]+@gmail\.com$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }

    private func passwordValidationError(_ password: String) -> String? {
        
        if password.count < 7 {
            return "Password should be greater than 6 characters"
        }
        
        let hasUppercase = password.range(of: "[A-Z]", options: .regularExpression) != nil
        if !hasUppercase {
            return "Uppercase letter is missing"
        }
        
        let hasLowercase = password.range(of: "[a-z]", options: .regularExpression) != nil
        if !hasLowercase {
            return "Lowercase letter is missing"
        }
        
        let hasNumber = password.range(of: "[0-9]", options: .regularExpression) != nil
        if !hasNumber {
            return "Numerical is missing"
        }
        
        let hasSpecialChar = password.range(of: "[^A-Za-z0-9]", options: .regularExpression) != nil
        if !hasSpecialChar {
            return "Special character is missing"
        }
        
        return nil //  Password is strong
    }

    // - Sign In
    
    func signIn() async {
        isLoading = true
        errorMessage = nil
        successMessage = nil

        do {
            try await authService.signIn(email: email, password: password)
            await fetchUserProfile()
            isAuthenticated = true
        } catch {
            // message for any login failure
            errorMessage = "Incorrect credentials"
        }

        isLoading = false
    }

    // MARK: - Sign Up (STRICT VALIDATION)
    
    func signUp() async {
        

        // Reset messages
        errorMessage = nil
        successMessage = nil

        //  Validate email
        guard isValidGmail(email) else {
            errorMessage = "Enter valid email id"
            return
        }

        //  Validate password match
        guard password == confirmPassword else {
            errorMessage = "Passwords are not matching"
            return
        }

        //  Validate password rules
        if let passwordError = passwordValidationError(password) {
            

            errorMessage = passwordError
            return
        }

        //  Only reach here if ALL validations pass
        isLoading = true

        do {
            try await authService.signUp(
                email: email,
                password: password
            )
            try await userService.createUserDocument(
                username: signupUsername,
                email: email
            )
            await fetchUserProfile()
            isAuthenticated = true
            
            successMessage = "Sign up successful! You can now sign in."

            // Clear fields after success
            email = ""
            password = ""
            confirmPassword = ""
        } catch {
            //  Firebase failed
            errorMessage = "Sign up failed"
        }

        isLoading = false
    }

    // Sign Out
    
    func signOut() {
        do {
            try authService.signOut()
            isAuthenticated = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // Password Reset
    
    func sendPasswordReset(email: String) async throws {
        try await authService.sendPasswordReset(email: email)
    }
}
