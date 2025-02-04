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
    var title = ""
    var body = ""
    var rating = 0
    var reviewer = ""
    var postedOn = Date()
    
    var dictionary: [String: Any] {
        return ["title": title, "body": body, "rating": rating, "reviewer": Auth.auth().currentUser?.email ?? "", "postedOn": Timestamp(date: Date())]
    }
}
