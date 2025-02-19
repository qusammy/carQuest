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
    @Published var userRentListings: [carListing] = [carListing]()
    @Published var allListings: [carListing] = [carListing]()
    @Published var recentListings: [carListing] = [carListing]()
    @Published var userID: String = ""
    @Published var likedVehicles: [carListing] = [carListing]()
    @Published var rating = Double()
    @Published var reviews = [Review]()
    
    func generateAllListings() {
        Firestore.firestore().collection("carListings").getDocuments() {snapshot, error in
            if error == nil && snapshot != nil {
                self.allListings = snapshot!.documents.map { doc in
                    //transforms firbase type "Timestamp" into type "Date"
                    let createdDate: Timestamp = doc["dateCreated"] as? Timestamp ?? Timestamp()
                    let create = createdDate.dateValue()
                    return carListing(id: doc.documentID, carMake: doc["carMake"] as? String ?? "", carModel: doc["carModel"] as? String ?? "", carType: doc["carType"] as? String ?? "", carYear: doc["carYear"] as? String ?? "", userID: doc["userID"] as? String ?? "", imageName: doc["imageName"] as? [String] ?? [""], listingType: doc["listingType"] as? String ?? "", listingPrice: doc["listingPrice"] as? String ?? "", carDescription: doc["carDescription"] as? String ?? "", listingID: doc["listingID"] as? String ?? "", dateCreated: create, usersLiked: doc["usersLiked"] as? [String] ?? [""], listingTitle: doc["listingTitle"] as? String ?? "")
                    
                }
            }
        }
    }
    
    func generateRentListings(){
        Firestore.firestore().collection("carListings").whereField("listingType", isEqualTo: "renting").getDocuments() {snapshot, error in
            if error == nil && snapshot != nil {
                self.rentListings = snapshot!.documents.map { doc in
                    //transforms firbase type "Timestamp" into type "Date"
                    let createdDate: Timestamp = doc["dateCreated"] as? Timestamp ?? Timestamp()
                    let create = createdDate.dateValue()
                    
                    return carListing(id: doc.documentID, carMake: doc["carMake"] as? String ?? "", carModel: doc["carModel"] as? String ?? "", carType: doc["carType"] as? String ?? "", carYear: doc["carYear"] as? String ?? "", userID: doc["userID"] as? String ?? "", imageName: doc["imageName"] as? [String] ?? [""], listingType: doc["listingType"] as? String ?? "", listingPrice: doc["listingPrice"] as? String ?? "", carDescription: doc["carDescription"] as? String ?? "", listingID: doc["listingID"] as? String ?? "", dateCreated: create, usersLiked: doc["usersLiked"] as? [String] ?? [""], listingTitle: doc["listingTitle"] as? String ?? "")
                    
//                    return carListing(id: doc.documentID, carDescription: doc["carDescrpition"] as? String ?? "", carMake: doc["carMake"] as? String ?? "", carModel: doc["carModel"] as? String ?? "", carType: doc["carType"] as? String ?? "", carYear: doc["carYear"] as? String ?? "", userID: doc["userID"] as? String ?? "", imageName: doc["imageName"] as? [String] ?? [""], listingType: doc["listingType"] as? String ?? "", listingID: doc["listingID"] as? String ?? "", dateCreated: create, usersLiked: doc["usersLiked"] as? [String] ?? [""])
                }
            }
        }
    }
    
    func generateLikedListings() throws{
        let user = try AuthenticationManager.shared.getAuthenticatedUser()
        
        Firestore.firestore().collection("carListings").whereField("usersLiked", arrayContains: user.uid).getDocuments() {snapshot, error in
            if error == nil && snapshot != nil {
                self.likedVehicles = snapshot!.documents.map { doc in
                    
                    return carListing(id: doc.documentID, carMake: doc["carMake"] as? String ?? "", carModel: doc["carModel"] as? String ?? "", carType: doc["carType"] as? String ?? "", carYear: doc["carYear"] as? String ?? "", userID: doc["userID"] as? String ?? "", imageName: doc["imageName"] as? [String] ?? [""], listingType: doc["listingType"] as? String ?? "", listingPrice: doc["listingPrice"] as? String ?? "", carDescription: doc["carDescription"] as? String ?? "", listingID: doc["listingID"] as? String ?? "", usersLiked: doc["usersLiked"] as? [String] ?? [""], listingTitle: doc["listingTitle"] as? String ?? "")
                    
                }
            }
        }
    }
    
    func generateAuctionListings() {
        Firestore.firestore().collection("carListings").whereField("listingType", isEqualTo: "auction").getDocuments() {snapshot, error in
            if error == nil && snapshot != nil {
                self.auctionListings = snapshot!.documents.map { doc in
                    //transforms firbase type "Timestamp" into type "Date"
                    let createdDate: Timestamp = doc["dateCreated"] as? Timestamp ?? Timestamp()
                    let create = createdDate.dateValue()
                    return carListing(id: doc.documentID, carMake: doc["carMake"] as? String ?? "", carModel: doc["carModel"] as? String ?? "", carType: doc["carType"] as? String ?? "", carYear: doc["carYear"] as? String ?? "", userID: doc["userID"] as? String ?? "", imageName: doc["imageName"] as? [String] ?? [""], listingType: doc["listingType"] as? String ?? "", listingPrice: doc["listingPrice"] as? String ?? "", carDescription: doc["carDescription"] as? String ?? "",  listingID: doc["listingID"] as? String ?? "", dateCreated: create, usersLiked: doc["usersLiked"] as? [String] ?? [""], listingTitle: doc["listingTitle"] as? String ?? "")
                    
                }
            }
        }
    }
    
    func generateBuyListings() {
        Firestore.firestore().collection("carListings").whereField("listingType", isEqualTo: "buying").getDocuments() {snapshot, error in
            if error == nil && snapshot != nil {
                self.buyListings = snapshot!.documents.map { doc in
                    //transforms firbase type "Timestamp" into type "Date"
                    let createdDate: Timestamp = doc["dateCreated"] as? Timestamp ?? Timestamp()
                    let create = createdDate.dateValue()
                    return carListing(id: doc.documentID, carMake: doc["carMake"] as? String ?? "", carModel: doc["carModel"] as? String ?? "", carType: doc["carType"] as? String ?? "", carYear: doc["carYear"] as? String ?? "", userID: doc["userID"] as? String ?? "", imageName: doc["imageName"] as? [String] ?? [""], listingType: doc["listingType"] as? String ?? "", listingPrice: doc["listingPrice"] as? String ?? "", carDescription: doc["carDescription"] as? String ?? "", listingID: doc["listingID"] as? String ?? "", dateCreated: create, usersLiked: doc["usersLiked"] as? [String] ?? [""], listingTitle: doc["listingTitle"] as? String ?? "")
                }
            }
        }
    }
    
    func generateMyRentListings() throws {
        let user = try AuthenticationManager.shared.getAuthenticatedUser()
        Firestore.firestore().collection("carListings").whereField("listingType", isEqualTo: "renting").whereField("userID", isEqualTo: user.uid).getDocuments() {snapshot, error in
            if error == nil && snapshot != nil {
                self.myrentListings = snapshot!.documents.map { doc in
                    //transforms firbase type "Timestamp" into type "Date"
                    let createdDate: Timestamp = doc["dateCreated"] as? Timestamp ?? Timestamp()
                    let create = createdDate.dateValue()
                    return carListing(id: doc.documentID, carMake: doc["carMake"] as? String ?? "", carModel: doc["carModel"] as? String ?? "", carType: doc["carType"] as? String ?? "", carYear: doc["carYear"] as? String ?? "", userID: doc["userID"] as? String ?? "", imageName: doc["imageName"] as? [String] ?? [""], listingType: doc["listingType"] as? String ?? "", listingPrice: doc["listingPrice"] as? String ?? "", carDescription: doc["carDescription"] as? String ?? "", listingID: doc["listingID"] as? String ?? "", dateCreated: create, usersLiked: doc["usersLiked"] as? [String] ?? [""], listingTitle: doc["listingTitle"] as? String ?? "")
                }
            }
        }
    }
    
    func generateUserRentListings(userID: String) throws {
        let user = try AuthenticationManager.shared.getAuthenticatedUser()
        Firestore.firestore().collection("carListings").whereField("listingType", isEqualTo: "renting").whereField("userID", isEqualTo: userID).getDocuments() {snapshot, error in
            if error == nil && snapshot != nil {
                self.userRentListings = snapshot!.documents.map { doc in
                    let createdDate: Timestamp = doc["dateCreated"] as? Timestamp ?? Timestamp()
                    let create = createdDate.dateValue()
                    return carListing(id: doc.documentID, carMake: doc["carMake"] as? String ?? "", carModel: doc["carModel"] as? String ?? "", carType: doc["carType"] as? String ?? "", carYear: doc["carYear"] as? String ?? "", userID: doc["userID"] as? String ?? "", imageName: doc["imageName"] as? [String] ?? [""], listingType: doc["listingType"] as? String ?? "", listingPrice: doc["listingPrice"] as? String ?? "", carDescription: doc["carDescription"] as? String ?? "", listingID: doc["listingID"] as? String ?? "", dateCreated: create, usersLiked: doc["usersLiked"] as? [String] ?? [""], listingTitle: doc["listingTitle"] as? String ?? "")
                }
            }
        }
    }
    
    
    func generateMyBuyListings() throws {
        let user = try AuthenticationManager.shared.getAuthenticatedUser()
        Firestore.firestore().collection("carListings").whereField("listingType", isEqualTo: "buying").whereField("userID", isEqualTo: user.uid).getDocuments() {snapshot, error in
            if error == nil && snapshot != nil {
                self.mybuyListings = snapshot!.documents.map { doc in
                    //transforms firbase type "Timestamp" into type "Date"
                    let createdDate: Timestamp = doc["dateCreated"] as? Timestamp ?? Timestamp()
                    let create = createdDate.dateValue()
                    return carListing(id: doc.documentID, carMake: doc["carMake"] as? String ?? "", carModel: doc["carModel"] as? String ?? "", carType: doc["carType"] as? String ?? "", carYear: doc["carYear"] as? String ?? "", userID: doc["userID"] as? String ?? "", imageName: doc["imageName"] as? [String] ?? [""], listingType: doc["listingType"] as? String ?? "", listingPrice: doc["listingPrice"] as? String ?? "", carDescription: doc["carDescription"] as? String ?? "", listingID: doc["listingID"] as? String ?? "", dateCreated: create, usersLiked: doc["usersLiked"] as? [String] ?? [""], listingTitle: doc["listingTitle"] as? String ?? "")
                }
            }
        }
    }
    
    func generateMyAuctionListings() throws {
        let user = try AuthenticationManager.shared.getAuthenticatedUser()
        Firestore.firestore().collection("carListings").whereField("listingType", isEqualTo: "auction").whereField("userID", isEqualTo: user.uid).getDocuments() {snapshot, error in
            if error == nil && snapshot != nil {
                self.myauctionListings = snapshot!.documents.map { doc in
                    
                    //transforms firbase type "Timestamp" into type "Date"
                    let createdDate: Timestamp = doc["dateCreated"] as? Timestamp ?? Timestamp()
                    let create = createdDate.dateValue()
                    return carListing(id: doc.documentID, carMake: doc["carMake"] as? String ?? "", carModel: doc["carModel"] as? String ?? "", carType: doc["carType"] as? String ?? "", carYear: doc["carYear"] as? String ?? "", userID: doc["userID"] as? String ?? "", imageName: doc["imageName"] as? [String] ?? [""], listingType: doc["listingType"] as? String ?? "", listingPrice: doc["listingPrice"] as? String ?? "", carDescription: doc["carDescription"] as? String ?? "",  listingID: doc["listingID"] as? String ?? "", dateCreated: create, usersLiked: doc["usersLiked"] as? [String] ?? [""], listingTitle: doc["listingTitle"] as? String ?? "")
                }
            }
        }
    }
    
        func getRatings(listingID: String) {
            self.reviews = [Review]()
            let ref = Firestore.firestore().collection("carListings")
            
            ref.getDocuments { snapshot1, err in
                
                for document in snapshot1!.documents {
                    if listingID == document.documentID {
                        var ratingList = [Int]()
                        Firestore.firestore().collection("carListings").document(listingID).collection("reviews").getDocuments() {snapshot, error in
                            if error == nil && snapshot != nil {
                                
                                //gets the average rating
                                for document1 in snapshot!.documents {
                                    ratingList.append(document1["rating"] as? Int ?? 0)
                                }
                                
                                if ratingList.count != 0 {
                                    var ratingTotal = 0
                                    var unroundedRating = 0.0
                                    for rating in ratingList {
                                        ratingTotal += rating
                                    }
                                    unroundedRating = Double(ratingTotal) / Double(ratingList.count)
                                    self.rating = round(unroundedRating * 10) / 10
                                    
                                    
                                    self.reviews = snapshot!.documents.map { doc in
                                        return Review(id: doc.documentID, userID: doc["userID"] as? String ?? "", userImage: doc["userImage"] as? String ?? "", userName: doc["userName"] as? String ?? "",title: doc["title"] as? String ?? "", body: doc["body"] as? String ?? "", rating: doc["rating"] as? Int ?? 0, postedOn: doc["postedOn"] as? Date ?? Date())
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    
    func generateUsersClicked() {
        let user = Auth.auth().currentUser
        if user != nil {
            let userID = user!.uid
            let ref = Firestore.firestore().collection("carListings")
            self.recentListings = [carListing]()
            
            ref.getDocuments { snapshot1, err in
                
                for document in snapshot1!.documents {
                    let listingID = document.documentID
                    
                    Firestore.firestore().collection("carListings").document(listingID).collection("usersClicked").getDocuments() {snapshot, error in
                        if error == nil && snapshot != nil {
                            for document1 in snapshot!.documents {
                                if document1.documentID == userID {
                                    
                                    //transforms firbase type "Timestamp" into type "Date"
                                    let dateNow = Date.now
                                    let modifiedDate = Calendar.current.date(byAdding: .day, value: -7, to: dateNow)!
                                    let listingDate: Timestamp = document1["timeAccessed"] as? Timestamp ?? Timestamp()
                                    let date = listingDate.dateValue()
                                    let createdDate: Timestamp = document["dateCreated"] as? Timestamp ?? Timestamp()
                                    let create = createdDate.dateValue()
                                    
                                    if modifiedDate <= date {
                                        self.recentListings.append(carListing(id: document.documentID, carMake: document["carMake"] as? String ?? "", carModel: document["carModel"] as? String ?? "", carType: document["carType"] as? String ?? "", carYear: document["carYear"] as? String ?? "", userID: document["userID"] as? String ?? "", imageName: document["imageName"] as? [String] ?? [""], listingType: document["listingType"] as? String ?? "", listingPrice: document["listingPrice"] as? String ?? "", carDescription: document["carDescription"] as? String ?? "", listingID: document["listingID"] as? String ?? "", dateCreated: create, timeAccessed: date, usersLiked: document["usersLiked"] as? [String] ?? [""]))
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
    

