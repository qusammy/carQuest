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
        
        fetchRecentMessages()
    }
    
    @Published var recentMessages = [ChatMessage]()
    
    private func fetchRecentMessages(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for recent messages \(error)"
                    return
                }
                querySnapshot?.documentChanges.forEach({ change in
                        let docId = change.document.documentID
                        
                        if let index = self.recentMessages.firstIndex(where: { 
                            rm in
                            return rm.documentId == docId
                        }) {
                            self.recentMessages.remove(at: index)
                        }
                        self.recentMessages.insert(.init(documentId: docId, data: change.document.data()), at: 0)
                        
                    
                    })
            }
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
            let uid = data["user_id"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let display_name = data["display_name"] as? String ?? ""
            let description = data["description"] as? String ?? ""
            let profileImageURL = data["profileImageURL"] as? String ?? "profileIcon"

            self.carUser = CarQuestUser(id: "", display_name: display_name, email: email, user_id: uid, profileImageURL: profileImageURL, description: description)
        }
    }
    
    func getUser(uid: String){
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("Failed to fetch current user", error)
                return
            }
            
            guard let data = snapshot?.data() else {
                self.errorMessage = "No data found"
                return }
            let uid = data["user_id"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let display_name = data["display_name"] as? String ?? ""
            let description = data["description"] as? String ?? ""
            let profileImageURL = data["profileImageURL"] as? String ?? "profileIcon"

            self.carUser = CarQuestUser(id: "", display_name: display_name, email: email, user_id: uid, profileImageURL: profileImageURL, description: description)
        }
    }

}

class UserInfoViewModel: ObservableObject {
    @Published var displayName: String = ""
    @Published var photoURL: String = ""
    @Published var description: String = ""
    
    func UserListingInfo() async throws{
        let user = try AuthenticationManager.shared.getAuthenticatedUser()
        let querySnapshot = try await Firestore.firestore().collection("users").whereField("user_id", isEqualTo: user.uid)
            .getDocuments()
          for document in querySnapshot.documents {
              let data = document.get("display_name") as? String
              self.displayName = data ?? ""
              let data2 = document.get("profileImageURL") as? String
              self.photoURL = data2 ?? ""
              let data3 = document.get("description") as? String
              self.description = data3 ?? ""
          }

    }
    
    func getUserInfo(listing: carListing) async throws{
        let db = Firestore.firestore()
        if listing.userID != nil {
            let document = try await db.collection("users").document(listing.userID!).getDocument()
            if document.exists {
                self.displayName = document.get("display_name") as! String
                self.photoURL = document.get("profileImageURL") as! String
                self.description = document.get("description") as! String
            }
        }
    }
}

