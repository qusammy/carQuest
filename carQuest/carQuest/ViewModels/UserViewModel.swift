//
//  User.swift
//  carQuest
//
//  Created by beraoud_981215 on 9/13/24.
//

import Foundation
import FirebaseFirestore
import Firebase
import SwiftUI
import PhotosUI

class UserProfileViewModel: ObservableObject{
    
    @Published var errorMessage = ""
    @Published var carUser: CarQuestUser?
    
    init(){
        fetchCurrentUser()
    }
    private func fetchCurrentUser(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "No user logged in"
            return }
        
        self.errorMessage = "\(uid)"

        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("Failed to fetch current user", error)
                return
            }
            
            guard let data = snapshot?.data() else {
                self.errorMessage = "No data found"
                return }
            let uid = data["uid"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let display_name = data["display_name"] as? String ?? ""
            let profileImageURL = data["profileImageURL"] as? String ?? "profileIcon"
            self.carUser = CarQuestUser(id: "", display_name: display_name, email: email, user_id: uid, profileImageURL: profileImageURL)
        }
    }
    

}

class UserInfoViewModel: ObservableObject {
    @Published var displayName: String = ""
    @Published var photoURL: String = ""
    
    func UserListingInfo() async throws{
        let user = try AuthenticationManager.shared.getAuthenticatedUser()
        let querySnapshot = try await Firestore.firestore().collection("users").whereField("user_id", isEqualTo: user.uid)
            .getDocuments()
          for document in querySnapshot.documents {
              let data = document.get("display_name") as? String
              self.displayName = data ?? ""
              let data2 = document.get("profileImageURL") as? String
              self.photoURL = data2 ?? ""
          }

    }
}
