//
//  Car.swift
//  carQuest
//
//  Created by beraoud_981215 on 9/13/24.
import Foundation
import Firebase
import FirebaseFirestore
struct carListing: Codable, Identifiable, Equatable {
    var id: String?
    
    var carDescription: String?
    var carMake: String?
    var carModel: String?
    var carType: String?
    var carYear: String?
    var userID: String?
    var imageName: String?
    var listingType: String?
    var imageData: Data?
    
//    init(carDescription: String, carMake: String, carModel: String, carType: String, carYear: String, userID: String, imageName: String, listingType: String) {
//        self.carDescription = carDescription
//        self.carMake = carMake
//        self.carModel = carModel
//        self.carType = carType
//        self.carYear = carYear
//        self.userID = userID
//        self.imageName = imageName
//        self.listingType = listingType
//    }
    
}
//extension carListing {
//    static var empty: carListing {
//        carListing(carDescription: "",
//                   carMake: "",
//                   carModel: "",
//                   carType: "",
//                   carYear: "",
//                   userID: "",
//                   imageName: "")
//    }
//}
