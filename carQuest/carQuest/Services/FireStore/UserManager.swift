//
//  UserManager.swift
//  carQuest
//
//  Created by beraoud_981215 on 9/13/24.
//

import Foundation
import FirebaseFirestore

struct CarQuestUser: Identifiable{
    var id: String { uid }
    
    let uid, email, profileImageURL, display_name: String
    
    init(data: [String: Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.display_name = data["display_name"] as? String ?? ""
        self.profileImageURL = data["profileImageURL"] as? String ?? ""
        
    }
}

struct CarQuestUser2: Identifiable{
    var id: String
    var display_name: String
    var email: String
    var user_id: String
    var profileImageURL: String
}

struct DBUser {
    let userId: String
    let email: String?
    let photoURL: String?
    let dateCreated: Date?
    let displayName: String?
}

final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    
    func createNewUser(auth: AuthDataResultModel) async throws {
        var userData: [String:Any] = [
            "user_id" : auth.uid,
            "date_created" : Timestamp(),

        ]
        if let email = auth.email {
            userData["email"] = auth.email
        }
        if let photoURL = auth.photoURL {
            userData["photoURL"] = auth.photoURL
        }
        if let displayName = auth.displayName {
            userData["display_name"] = displayName
        }

        try await Firestore.firestore().collection("users").document(auth.uid).setData(userData, merge: false)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        let snapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()
        
        guard let data = snapshot.data(), let userId = data["user_id"] as? String else {
            throw URLError(.badServerResponse)
        }
        
        let email = data["email"] as? String
        let photoURL = data["photoURL"] as? String
        let dateCreated = data["date_created"] as? Date
        let displayName = data["display_name"] as? String
        
        return DBUser(userId: userId, email: email, photoURL: photoURL, dateCreated: dateCreated, displayName: displayName)
    }
}
