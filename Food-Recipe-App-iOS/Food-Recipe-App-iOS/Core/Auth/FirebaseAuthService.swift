import Foundation
import FirebaseAuth

final class FirebaseAuthService: AuthService {

    func signIn(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }

    func signUp(email: String, password: String) async throws {
        try await Auth.auth().createUser(withEmail: email, password: password)
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }

    func getCurrentUserId() -> String? {
        return Auth.auth().currentUser?.uid
    }

    // ADD THIS METHOD (this fixes your error)
    func sendPasswordReset(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
}
