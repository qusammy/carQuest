//
//  AuthenticationManager.swift
//  carQuest
//
//  Created by hollande_894789 on 9/13/24.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoURL: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoURL = user.photoURL?.absoluteString
    }
}

final class AuthenticationManager {
    static let shared = AuthenticationManager()
    private init() {
        
    }
    @discardableResult
    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws  -> AuthDataResultModel{
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await signInGoogle(credential: credential)
    }
    func signInGoogle(credential: AuthCredential) async throws  -> AuthDataResultModel{
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
}


