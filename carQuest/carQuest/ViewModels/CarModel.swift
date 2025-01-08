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
    @Published var userID: String = ""
    @Published var listingFromList: Int = 0
    
    
    func generateRentListings(){
        Firestore.firestore().collection("carListings").whereField("listingType", isEqualTo: "renting").getDocuments() {snapshot, error in
            if error == nil && snapshot != nil {
                self.rentListings = snapshot!.documents.map { doc in
                    
                    return carListing(id: doc.documentID, carDescription: doc["carDescrpition"] as? String ?? "", carMake: doc["carMake"] as? String ?? "", carModel: doc["carModel"] as? String ?? "", carType: doc["carType"] as? String ?? "", carYear: doc["carYear"] as? String ?? "", userID: doc["userID"] as? String ?? "", imageName: doc["imageName"] as? String ?? "", listingType: doc["listingType"] as? String ?? "", listingID: doc["listingID"] as? String ?? "")
                    
                }
            }
        }
    }
    
    
    
}
