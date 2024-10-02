//
//  Car.swift
//  carQuest
//
//  Created by beraoud_981215 on 9/13/24.
import Foundation
import Firebase
import FirebaseFirestore
struct carListing: Codable, Identifiable {
    @DocumentID var id: String?
    
    var carDescription: String
    var carMake: String
    var carModel: String
    var carType: String
    var carYear: String
    
    var userID: String
}
extension carListing {
    static var empty: carListing {
        carListing(carDescription: "",
                   carMake: "",
                   carModel: "",
                   carType: "",
                   carYear: "",
                   userID: "")
    }
}
