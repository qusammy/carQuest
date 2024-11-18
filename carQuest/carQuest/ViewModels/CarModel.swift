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

@MainActor
 final class ListingViewModel: ObservableObject {
    @Published var carYear: String = ""
    @Published var carModel: String = ""
    @Published var carType: String = ""
    @Published var carMake: String = ""
    @Published var carDescription: String = ""
    @Published var imageName: String = ""
    @Published var allListings = [carListing]()
    @Published var userID: String = ""
    @Published var listingType: String = ""
     @Published var listingIndex: Int = 0
     func getLisitngInfo() {
         
     }

    func generateListings(){
        Firestore.firestore().collection("carListings").getDocuments() {snapshot, error in
                if error == nil {
                    
                    if let snapshot = snapshot {
                        
                        self.allListings = snapshot.documents.map { doc in
                            
                            return carListing(id: doc.documentID, carDescription: doc["carDescrpition"] as? String ?? "", carMake: doc["carMake"] as? String ?? "", carModel: doc["carModel"] as? String ?? "", carType: doc["carType"] as? String ?? "", carYear: doc["carYear"] as? String ?? "", userID: doc["userID"] as? String ?? "", imageName: doc["imageName"] as? String ?? "", listingType: doc["listingType"] as? String ?? "")
                        }
                    }
                }
            }

    }
}
