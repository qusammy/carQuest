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
import FirebaseFirestore

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    
    func signOut() throws{
        try AuthenticationManager.shared.signOut()
    }
    
    func deleteAccount() async throws {
        try await AuthenticationManager.shared.deleteUser()
        do {
            try await Firestore.firestore().collection("users").document(user?.userId ?? "").delete()
          print("Document successfully removed!")
        } catch {
          print("Error removing document: \(error)")
        }
    }
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
        
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
        
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        try await UserManager.shared.createNewUser(auth: authDataResult)
    }
}

@MainActor
final class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorText = ""
    @Published var displayName = ""
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else{
            return
        }
        let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        try await UserManager.shared.createNewUser(auth: authDataResult)
        
        let userRef = Firestore.firestore().collection("users").document("\(Auth.auth().currentUser?.uid ?? "")")

        do {
          try await userRef.updateData([
            "display_name": displayName
          ])
          print("Document successfully updated")
        } catch {
          print("Error updating document: \(error)")
        }
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
    
    func getDisplayName() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(userID).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.get("display_name") as? String
                self.displayName = dataDescription ?? ""
            } else {
                print("Document does not exist")
            }
        }
    }

}
