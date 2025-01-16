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
    @Published var allListings: [carListing] = [carListing]()
    @Published var recentListings: [carListing] = [carListing]()
    @Published var userID: String = ""
    
    
    func generateAllListings() {
        Firestore.firestore().collection("carListings").getDocuments() {snapshot, error in
            if error == nil && snapshot != nil {
                self.allListings = snapshot!.documents.map { doc in
                    
                    return carListing(id: doc.documentID, carDescription: doc["carDescrpition"] as? String ?? "", carMake: doc["carMake"] as? String ?? "", carModel: doc["carModel"] as? String ?? "", carType: doc["carType"] as? String ?? "", carYear: doc["carYear"] as? String ?? "", userID: doc["userID"] as? String ?? "", imageName: doc["imageName"] as? String ?? "", listingType: doc["listingType"] as? String ?? "", listingID: doc["listingID"] as? String ?? "", dateCreated: doc["dateCreated"] as? Date ?? Date())
                    
                }
            }
        }
    }
    
    func generateRentListings(){
        Firestore.firestore().collection("carListings").whereField("listingType", isEqualTo: "renting").getDocuments() {snapshot, error in
            if error == nil && snapshot != nil {
                self.rentListings = snapshot!.documents.map { doc in
                    
                    return carListing(id: doc.documentID, carDescription: doc["carDescrpition"] as? String ?? "", carMake: doc["carMake"] as? String ?? "", carModel: doc["carModel"] as? String ?? "", carType: doc["carType"] as? String ?? "", carYear: doc["carYear"] as? String ?? "", userID: doc["userID"] as? String ?? "", imageName: doc["imageName"] as? String ?? "", listingType: doc["listingType"] as? String ?? "", listingID: doc["listingID"] as? String ?? "", dateCreated: doc["dateCreated"] as? Date ?? Date())
                    
                }
            }
        }
    }
    
    func generateAuctionListings() {
        Firestore.firestore().collection("carListings").whereField("listingType", isEqualTo: "auction").getDocuments() {snapshot, error in
            if error == nil && snapshot != nil {
                self.auctionListings = snapshot!.documents.map { doc in
                    
                    return carListing(id: doc.documentID, carDescription: doc["carDescrpition"] as? String ?? "", carMake: doc["carMake"] as? String ?? "", carModel: doc["carModel"] as? String ?? "", carType: doc["carType"] as? String ?? "", carYear: doc["carYear"] as? String ?? "", userID: doc["userID"] as? String ?? "", imageName: doc["imageName"] as? String ?? "", listingType: doc["listingType"] as? String ?? "", listingID: doc["listingID"] as? String ?? "", dateCreated: doc["dateCreated"] as? Date ?? Date())
                    
                }
            }
        }
    }
    
    func generateBuyListings() {
        Firestore.firestore().collection("carListings").whereField("listingType", isEqualTo: "buying").getDocuments() {snapshot, error in
            if error == nil && snapshot != nil {
                self.buyListings = snapshot!.documents.map { doc in
                    
                    return carListing(id: doc.documentID, carDescription: doc["carDescrpition"] as? String ?? "", carMake: doc["carMake"] as? String ?? "", carModel: doc["carModel"] as? String ?? "", carType: doc["carType"] as? String ?? "", carYear: doc["carYear"] as? String ?? "", userID: doc["userID"] as? String ?? "", imageName: doc["imageName"] as? String ?? "", listingType: doc["listingType"] as? String ?? "", listingID: doc["listingID"] as? String ?? "", dateCreated: doc["dateCreated"] as? Date ?? Date())
                }
            }
        }
    }
    
    func generateMyRentListings() throws {
        let user = try AuthenticationManager.shared.getAuthenticatedUser()
        Firestore.firestore().collection("carListings").whereField("listingType", isEqualTo: "renting").whereField("userID", isEqualTo: user.uid).getDocuments() {snapshot, error in
            if error == nil && snapshot != nil {
                self.myrentListings = snapshot!.documents.map { doc in
                    
                    return carListing(id: doc.documentID, carDescription: doc["carDescrpition"] as? String ?? "", carMake: doc["carMake"] as? String ?? "", carModel: doc["carModel"] as? String ?? "", carType: doc["carType"] as? String ?? "", carYear: doc["carYear"] as? String ?? "", userID: doc["userID"] as? String ?? "", imageName: doc["imageName"] as? String ?? "", listingType: doc["listingType"] as? String ?? "", listingID: doc["listingID"] as? String ?? "", dateCreated: doc["dateCreated"] as? Date ?? Date())
                }
            }
        }
    }

    
    func generateMyBuyListings() throws {
        let user = try AuthenticationManager.shared.getAuthenticatedUser()
        Firestore.firestore().collection("carListings").whereField("listingType", isEqualTo: "buying").whereField("userID", isEqualTo: user.uid).getDocuments() {snapshot, error in
            if error == nil && snapshot != nil {
                self.mybuyListings = snapshot!.documents.map { doc in
                    
                    return carListing(id: doc.documentID, carDescription: doc["carDescrpition"] as? String ?? "", carMake: doc["carMake"] as? String ?? "", carModel: doc["carModel"] as? String ?? "", carType: doc["carType"] as? String ?? "", carYear: doc["carYear"] as? String ?? "", userID: doc["userID"] as? String ?? "", imageName: doc["imageName"] as? String ?? "", listingType: doc["listingType"] as? String ?? "", listingID: doc["listingID"] as? String ?? "", dateCreated: doc["dateCreated"] as? Date ?? Date())
                }
                
            }
        }
    }
    
    func generateMyAuctionListings() throws {
        let user = try AuthenticationManager.shared.getAuthenticatedUser()
        Firestore.firestore().collection("carListings").whereField("listingType", isEqualTo: "auction").whereField("userID", isEqualTo: user.uid).getDocuments() {snapshot, error in
            if error == nil && snapshot != nil {
                self.myauctionListings = snapshot!.documents.map { doc in
                    
                    return carListing(id: doc.documentID, carDescription: doc["carDescrpition"] as? String ?? "", carMake: doc["carMake"] as? String ?? "", carModel: doc["carModel"] as? String ?? "", carType: doc["carType"] as? String ?? "", carYear: doc["carYear"] as? String ?? "", userID: doc["userID"] as? String ?? "", imageName: doc["imageName"] as? String ?? "", listingType: doc["listingType"] as? String ?? "", listingID: doc["listingID"] as? String ?? "", dateCreated: doc["dateCreated"] as? Date ?? Date())
                }
            }
            
        }
    }
    
    func generateUsersClicked() {
        let user = Auth.auth().currentUser
        let userID = user!.uid
        let ref = Firestore.firestore().collection("carListings")
        
        
        ref.getDocuments { snapshot1, err in
            
            for document in snapshot1!.documents {
                let listingID = document.documentID
                
                Firestore.firestore().collection("carListings").document(listingID).collection("usersClicked").getDocuments() {snapshot, error in
                    if error == nil && snapshot != nil {
                        for document1 in snapshot!.documents {
                            if document1.documentID == userID {
                                self.recentListings = snapshot!.documents.map { doc in
                                        return carListing(id: document.documentID, carDescription: document["carDescrpition"] as? String ?? "", carMake: document["carMake"] as? String ?? "", carModel: document["carModel"] as? String ?? "", carType: document["carType"] as? String ?? "", carYear: document["carYear"] as? String ?? "", userID: document["userID"] as? String ?? "", imageName: document["imageName"] as? String ?? "", listingType: document["listingType"] as? String ?? "", listingID: document["listingID"] as? String ?? "", dateCreated: document["dateCreated"] as? Date ?? Date(), timeAccessed: doc["timeAccessed"] as? Date ?? Date())
                                    
                                }
                            }
                        }
                    }
                }
            }
            
        }
    }
    
}
