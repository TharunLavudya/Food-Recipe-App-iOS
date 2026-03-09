import Foundation

protocol AuthService {
    func signIn(email: String, password: String) async throws
    func signUp(email: String, password: String) async throws
    func signOut() throws
    func getCurrentUserId() -> String?

    func sendPasswordReset(email: String) async throws
}

