//
//  Review.swift
//  carQuest
//
//  Created by hollande_894789 on 1/31/25.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct Review: Identifiable, Codable {
    
    @DocumentID var id: String?
    var userID = ""
    var userImage = ""
    var userName = ""
    var title = ""
    var body = ""
    var rating = 0
    var postedOn = Date()
    
    var dictionary: [String: Any] {
        return ["userID": userID, "userImage": userImage, "userName": userName, "title": title, "body": body, "rating": rating, "postedOn": Timestamp(date: Date())]
    }
}
