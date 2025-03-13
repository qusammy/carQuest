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
    var carMileage: String?
    var carTitle: String?
    var imageData: Data?
    var listingID: String?
    var dateCreated: Date?
    var timeAccessed: Date?
    var usersLiked: [String?]
    var listingTitle: String?
    var location: String?
    var startBid: String?
    var buyout: String?
    var endTime: Date?

}

struct userClicked: Codable, Equatable {
    var id: String?
    var timeAccessed: Date?
    
}
