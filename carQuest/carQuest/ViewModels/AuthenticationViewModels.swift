//
//  AuthenticationViewModels.swift
//  carQuest
//
//  Created by hollande_894789 on 9/26/24.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth

@MainActor
final class ProfileViewModel: ObservableObject {
    
    func signOut() throws{
        try AuthenticationManager.shared.signOut()
    }
    
}

struct GoogleSignInResultModel {
    let idToken: String
    let accessToken: String
}

@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    func googleSignIn() async throws{
        guard let topVC = Utilities.shared.topViewController() else {
            throw URLError(.cannotFindHost)
        }
        
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        guard let idToken: String = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        let accessToken: String = gidSignInResult.user.accessToken.tokenString
                
        let tokens = GoogleSignInResultModel(idToken: idToken, accessToken: accessToken)
        try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
    }
}

@MainActor
final class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorText = ""
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else{
            return
        }
        try await AuthenticationManager.shared.createUser(email: email, password: password)
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            if email.isEmpty {
                errorText = "Please enter a vaild email"
            }else if password.isEmpty {
                errorText = "Please enter a password"
            }
            return
        }
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
}
