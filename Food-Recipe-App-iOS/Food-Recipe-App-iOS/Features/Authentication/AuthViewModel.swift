import Foundation
import SwiftUI
import Combine
import FirebaseAuth

@MainActor
final class AuthViewModel: ObservableObject {

    // Auth Fields
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var signupUsername: String = ""

    // Profile Fields (used by ProfileView / EditProfileView)
    @Published var username: String = ""
    @Published var bio: String = ""
    @Published var gender: String = "Male"

    // UI State
    @Published var isLoading: Bool = false
    @Published var emailError: String?
    @Published var passwordError: String?
    @Published var confirmPasswordError: String?
    @Published var generalError: String?
    @Published var successMessage: String?
    @Published var isAuthenticated: Bool = false

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

    //  Profile

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

    func updateProfile(newUsername: String, newBio: String, newGender: String) async {
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
            generalError = "Profile update failed"
        }
    }

    //  Validation

    func isValidGmail(_ email: String) -> Bool {
        let pattern = #"^[A-Z0-9a-z._%+-]+@gmail\.com$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }

    struct PasswordCheck {
        var hasUppercase = false
        var hasLowercase = false
        var hasNumber = false
        var hasSpecial = false
        var hasMinLength = false
    }

    func checkPassword(_ password: String) -> PasswordCheck {
        PasswordCheck(
            hasUppercase: password.range(of: "[A-Z]", options: .regularExpression) != nil,
            hasLowercase: password.range(of: "[a-z]", options: .regularExpression) != nil,
            hasNumber: password.range(of: "[0-9]", options: .regularExpression) != nil,
            hasSpecial: password.range(of: "[^A-Za-z0-9]", options: .regularExpression) != nil,
            hasMinLength: password.count >= 7
        )
    }

    enum PasswordStrength {
        case weak, medium, strong
    }

    func passwordStrength(_ password: String) -> PasswordStrength {
        let c = checkPassword(password)
        let score = [c.hasUppercase, c.hasLowercase, c.hasNumber, c.hasSpecial, c.hasMinLength].filter { $0 }.count

        switch score {
        case 0...2: return .weak
        case 3...4: return .medium
        default: return .strong
        }
    }

    func missingPasswordRules(_ password: String) -> [String] {
        let c = checkPassword(password)
        var missing: [String] = []

        if !c.hasUppercase { missing.append("uppercase letter") }
        if !c.hasLowercase { missing.append("lowercase letter") }
        if !c.hasNumber { missing.append("number") }
        if !c.hasSpecial { missing.append("special character") }
        if !c.hasMinLength { missing.append("at least 7 characters") }

        return missing
    }

    func clearErrors() {
        emailError = nil
        passwordError = nil
        confirmPasswordError = nil
        generalError = nil
        successMessage = nil
    }

    //  Sign In

    func signIn() async {
        clearErrors()
        isLoading = true

        if !isValidGmail(email) {
            emailError = "Invalid email format (@gmail.com only)"
            isLoading = false
            return
        }

        do {
            try await authService.signIn(email: email, password: password)
            await fetchUserProfile()
            isAuthenticated = true
        } catch {
            generalError = "Incorrect credentials"
        }

        isLoading = false
    }

    //  Sign Up

    func signUp() async {
        clearErrors()
        isLoading = true

        var hasError = false

        if !isValidGmail(email) {
            emailError = "Enter valid @gmail.com email"
            hasError = true
        }

        if password != confirmPassword {
            confirmPasswordError = "Passwords are not matching"
            hasError = true
        }

        let missing = missingPasswordRules(password)
        if !missing.isEmpty {
            passwordError = "Missing: " + missing.joined(separator: ", ")
            hasError = true
        }

        if hasError {
            isLoading = false
            return
        }

        do {
            try await authService.signUp(email: email, password: password)
            try await userService.createUserDocument(username: signupUsername, email: email)
            

            successMessage = "Sign up successful! You can now sign in."
            

            email = ""
            password = ""
            confirmPassword = ""
            signupUsername = ""
        } catch {
            generalError = "Sign up failed"
        }

        isLoading = false
    }

    //  Password Reset

    func sendPasswordReset(email: String) async throws {
        try await authService.sendPasswordReset(email: email)
    }

    //  Sign Out

    func signOut() {
        do {
            try authService.signOut()
            isAuthenticated = false
        } catch {
            generalError = error.localizedDescription
        }
    }
}
