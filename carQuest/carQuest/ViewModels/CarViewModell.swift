//
//  CarModel.swift
//  carQuest
//
//  Created by beraoud_981215 on 9/13/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
final class ListingViewModel: ObservableObject {
    @Published var carYear: String = ""
    @Published var carModel: String = ""
    @Published var carType: String = ""
    @Published var carMake: String = ""
    @Published var carDescription: String = ""
    @Published var additionalListing: Int = 0
    
    func getListingInfo() throws{
        additionalListing = 0
        guard let userID = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore().collection("carListings").document("\(additionalListing)\(userID)").getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.get("carYear") as? String
                self.carYear = data ?? ""
                let data1 = document.get("carModel") as? String
                self.carModel = data1 ?? ""
                let data2 = document.get("carType") as? String
                self.carType = data2 ?? ""
                let data3 = document.get("carMake") as? String
                self.carMake = data3 ?? ""
                let data4 = document.get("carDescription") as? String
                self.carDescription = data4 ?? ""
            } else {
                print("Document \(self.additionalListing)\(userID) does not exist")
                self.additionalListing += 1
            }
        }

    }
}
