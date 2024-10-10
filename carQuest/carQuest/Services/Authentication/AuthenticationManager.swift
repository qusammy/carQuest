//
//  AuthenticationManager.swift
//  carQuest
//
//  Created by hollande_894789 on 9/13/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


enum userError: Error {
    case runtimeError(String)
}

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoURL: String?
    let displayName: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoURL = user.photoURL?.absoluteString
        self.displayName = user.displayName
    }
}

final class AuthenticationManager {
    static let shared = AuthenticationManager()
    private init() {
        
    }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw userError.runtimeError("No user signed in")
        }
        return AuthDataResultModel(user: user)
    }
    

    
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    @discardableResult
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func resetPassword(email: String) async throws{
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func deleteUser() async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        try await user.delete()
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


