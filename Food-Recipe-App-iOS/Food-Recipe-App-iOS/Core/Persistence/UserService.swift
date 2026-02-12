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
                "createdAt": Timestamp()
            ])
    }
}
