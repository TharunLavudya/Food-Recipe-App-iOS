//
//  UserService.swift
//  Food-Recipe-App-iOS
//
//  Created by rentamac on 2/11/26.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class UserService {

    private let db = Firestore.firestore()

    func createUserDocument(
        username: String,
        email: String
    ) async throws {

        guard let uid = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "UID Missing", code: 401)
        }

        try await db
            .collection("users")
            .document(uid)
            .setData([
                "username": username,
                "email": email,
                "bio": "",
                "gender": "Male",
                "createdAt": Timestamp()
            ])
    }
    
    func fetchUserProfile() async throws -> (username: String, bio: String, gender: String) {

        guard let uid = Auth.auth().currentUser?.uid else {
            throw URLError(.badURL)
        }

        let snapshot = try await db
            .collection("users")
            .document(uid)
            .getDocument()

        guard let data = snapshot.data() else {
            return ("", "", "Male")
        }

        let username = data["username"] as? String ?? ""
        let bio = data["bio"] as? String ?? ""
        let gender = data["gender"] as? String ?? "Male"

        return (username, bio, gender)
    }
    
    func updateUserProfile(
        username: String,
        bio: String,
        gender: String
    ) async throws {

        guard let uid = Auth.auth().currentUser?.uid else {
            throw URLError(.badURL)
        }

        try await db
            .collection("users")
            .document(uid)
            .setData([
                "username": username.capitalized,
                "bio": bio,
                "gender": gender
            ], merge: true)
    }

}
