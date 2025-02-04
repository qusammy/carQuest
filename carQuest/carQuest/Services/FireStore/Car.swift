//
//  Car.swift
//  carQuest
//
//  Created by beraoud_981215 on 9/13/24.
import Foundation
import Firebase
import FirebaseFirestore
import FirebaseCore
struct carListing: Codable, Identifiable, Equatable {
    var id: String?
    
    var carMake: String?
    var carModel: String?
    var carType: String?
    var carYear: String?
    var userID: String?
    var imageName: [String]?
    var listingType: String?
    var listingPrice: String?
    var carDescription: String?
    var imageData: Data?
    var listingID: String?
    var dateCreated: Date?
    var timeAccessed: Date?
    var usersLiked: [String?]
    var listingTitle: String?
    

}

struct userClicked: Codable, Equatable {
    var id: String?
    var timeAccessed: Date?
    
}
