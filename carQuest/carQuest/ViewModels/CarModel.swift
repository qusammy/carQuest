//
//  CarModel.swift
//  carQuest
//
//  Created by beraoud_981215 on 9/13/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class ListingViewModel: ObservableObject {
    @Published var carYear: String = ""
    @Published var carModel: String = ""
    @Published var carType: String = ""
    @Published var carMake: String = ""
    @Published var carDescription: String = ""
    
    func getListingInfo() async throws{
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let querySnapshot = try await Firestore.firestore().collection("carListings").whereField("userID", isEqualTo: userID)
            .getDocuments()
          for document in querySnapshot.documents {
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
          }
    }
}
