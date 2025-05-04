//
//  FirebaseAuthService.swift
//  BookExpertsApp
//
//  Created by SubbaRao MV on 04/05/25.
//

import FirebaseAuth
import GoogleSignIn
import FirebaseCore

final class FirebaseAuthService: AuthServiceProtocol {
    func signInWithGoogle(presenting: UIViewController) async throws -> User {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw NSError(domain: "Auth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing client ID"])
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: presenting)
        let user = result.user

        guard let idToken = user.idToken?.tokenString else {
            throw NSError(domain: "Auth", code: -1, userInfo: [NSLocalizedDescriptionKey: "No ID token"])
        }

        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
        let authResult = try await Auth.auth().signIn(with: credential)

        let firebaseUser = authResult.user
        
        return User(
            id: firebaseUser.uid,
            name: firebaseUser.displayName ?? "Unknown",
            email: firebaseUser.email ?? "No email",
            photoURL: firebaseUser.photoURL?.absoluteString ?? ""
        )
    }
}


