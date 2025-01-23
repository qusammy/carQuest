//
//  CarModel.swift
//  carQuest
//
//  Created by beraoud_981215 on 9/13/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage


class ListingViewModel: ObservableObject {
    @Published var rentListings: [carListing] = [carListing]()
    @Published var auctionListings: [carListing] = [carListing]()
    @Published var buyListings: [carListing] = [carListing]()
    @Published var myrentListings: [carListing] = [carListing]()
    @Published var myauctionListings: [carListing] = [carListing]()
    @Published var mybuyListings: [carListing] = [carListing]()
    @Published var likedVehicles: [carListing] = [carListing]()
    @Published var userID: String = ""
    @Published var listingFromList: Int = 0
    @Published var usersLiked: [String] = [""]
    
    func generateRentListings(){
        Firestore.firestore().collection("carListings").whereField("listingType", isEqualTo: "renting").getDocuments() {snapshot, error in
            if error == nil && snapshot != nil {
                self.rentListings = snapshot!.documents.map { doc in
                    
                    return carListing(id: doc.documentID, carDescription: doc["carDescrpition"] as? String ?? "", carMake: doc["carMake"] as? String ?? "", carModel: doc["carModel"] as? String ?? "", carType: doc["carType"] as? String ?? "", carYear: doc["carYear"] as? String ?? "", userID: doc["userID"] as? String ?? "", imageName: doc["imageName"] as? String ?? "", listingType: doc["listingType"] as? String ?? "", listingID: doc["listingID"] as? String ?? "", usersLiked: doc["usersLiked"] as? [String] ?? [""])
                    
                }
            }
        }
    }
    
    func generateLikedListings() throws{
        let user = try AuthenticationManager.shared.getAuthenticatedUser()

        Firestore.firestore().collection("carListings").whereField("usersLiked", arrayContains: user.uid).getDocuments() {snapshot, error in
                if error == nil && snapshot != nil {
                    self.likedVehicles = snapshot!.documents.map { doc in
                        
                        return carListing(id: doc.documentID, carDescription: doc["carDescrpition"] as? String ?? "", carMake: doc["carMake"] as? String ?? "", carModel: doc["carModel"] as? String ?? "", carType: doc["carType"] as? String ?? "", carYear: doc["carYear"] as? String ?? "", userID: doc["userID"] as? String ?? "", imageName: doc["imageName"] as? String ?? "", listingType: doc["listingType"] as? String ?? "", listingID: doc["listingID"] as? String ?? "", usersLiked: doc["usersLiked"] as? [String] ?? [""])
                        
                    }
                }
            }
        }
    
    func generateAuctionListings() {
        Firestore.firestore().collection("carListings").whereField("listingType", isEqualTo: "auction").getDocuments() {snapshot, error in
            if error == nil && snapshot != nil {
                self.auctionListings = snapshot!.documents.map { doc in
                    
                    return carListing(id: doc.documentID, carDescription: doc["carDescrpition"] as? String ?? "", carMake: doc["carMake"] as? String ?? "", carModel: doc["carModel"] as? String ?? "", carType: doc["carType"] as? String ?? "", carYear: doc["carYear"] as? String ?? "", userID: doc["userID"] as? String ?? "", imageName: doc["imageName"] as? String ?? "", listingType: doc["listingType"] as? String ?? "", listingID: doc["listingID"] as? String ?? "", usersLiked: doc["usersLiked"] as? [String] ?? [""])
                    
                }
            }
        }
    }
    
    func generateBuyListings() {
        Firestore.firestore().collection("carListings").whereField("listingType", isEqualTo: "buying").getDocuments() {snapshot, error in
            if error == nil && snapshot != nil {
                self.buyListings = snapshot!.documents.map { doc in
                    
                    return carListing(id: doc.documentID, carDescription: doc["carDescrpition"] as? String ?? "", carMake: doc["carMake"] as? String ?? "", carModel: doc["carModel"] as? String ?? "", carType: doc["carType"] as? String ?? "", carYear: doc["carYear"] as? String ?? "", userID: doc["userID"] as? String ?? "", imageName: doc["imageName"] as? String ?? "", listingType: doc["listingType"] as? String ?? "", listingID: doc["listingID"] as? String ?? "", usersLiked: doc["usersLiked"] as? [String] ?? [""])
                    
                }
            }
        }
    }
    
    func generateMyRentListings() throws {
        let user = try AuthenticationManager.shared.getAuthenticatedUser()
        Firestore.firestore().collection("carListings").whereField("listingType", isEqualTo: "renting").whereField("userID", isEqualTo: user.uid).getDocuments() {snapshot, error in
            if error == nil && snapshot != nil {
                self.myrentListings = snapshot!.documents.map { doc in
                    
                    return carListing(id: doc.documentID, carDescription: doc["carDescrpition"] as? String ?? "", carMake: doc["carMake"] as? String ?? "", carModel: doc["carModel"] as? String ?? "", carType: doc["carType"] as? String ?? "", carYear: doc["carYear"] as? String ?? "", userID: doc["userID"] as? String ?? "", imageName: doc["imageName"] as? String ?? "", listingType: doc["listingType"] as? String ?? "", listingID: doc["listingID"] as? String ?? "", usersLiked: doc["usersLiked"] as? [String] ?? [""])
                    
                }
            }
        }
    }

    
    func generateMyBuyListings() throws {
        let user = try AuthenticationManager.shared.getAuthenticatedUser()
        Firestore.firestore().collection("carListings").whereField("listingType", isEqualTo: "buying").whereField("userID", isEqualTo: user.uid).getDocuments() {snapshot, error in
            if error == nil && snapshot != nil {
                self.mybuyListings = snapshot!.documents.map { doc in
                    
                    return carListing(id: doc.documentID, carDescription: doc["carDescrpition"] as? String ?? "", carMake: doc["carMake"] as? String ?? "", carModel: doc["carModel"] as? String ?? "", carType: doc["carType"] as? String ?? "", carYear: doc["carYear"] as? String ?? "", userID: doc["userID"] as? String ?? "", imageName: doc["imageName"] as? String ?? "", listingType: doc["listingType"] as? String ?? "", listingID: doc["listingID"] as? String ?? "", usersLiked: doc["usersLiked"] as? [String] ?? [""])
                    
                }
                
            }
        }
    }
    
    func generateMyAuctionListings() throws {
        let user = try AuthenticationManager.shared.getAuthenticatedUser()
        Firestore.firestore().collection("carListings").whereField("listingType", isEqualTo: "auction").whereField("userID", isEqualTo: user.uid).getDocuments() {snapshot, error in
            if error == nil && snapshot != nil {
                self.myauctionListings = snapshot!.documents.map { doc in
                    
                    return carListing(id: doc.documentID, carDescription: doc["carDescrpition"] as? String ?? "", carMake: doc["carMake"] as? String ?? "", carModel: doc["carModel"] as? String ?? "", carType: doc["carType"] as? String ?? "", carYear: doc["carYear"] as? String ?? "", userID: doc["userID"] as? String ?? "", imageName: doc["imageName"] as? String ?? "", listingType: doc["listingType"] as? String ?? "", listingID: doc["listingID"] as? String ?? "", usersLiked: doc["usersLiked"] as? [String] ?? [""])
                    
                }
            }
            
        }
    }
    
}
