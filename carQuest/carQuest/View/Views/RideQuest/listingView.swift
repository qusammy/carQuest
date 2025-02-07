//
//  listingView.swift
//  carQuest
//
//  Created by Maddy Quinn on 9/24/24.
//
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct listingView: View {
    
    @State private var isLiked: Bool = false
    @Binding var showSignInView: Bool
    @StateObject var viewModel = ListingViewModel()
    @StateObject var userViewModel = UserInfoViewModel()
    @State var listingName: String?
    @State var listing: carListing?
    @State var user: String?
    @State private var reviewIsShown: Bool = false
    @State private var rating: Double = 0.0

    var body: some View {
        NavigationStack{
            VStack{
                ScrollView{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            ForEach((listing?.imageName)!, id: \.self) { image in
                                WebImage(url: URL(string: image))
                                    .resizable()
                                    .frame(width:300, height:300)
                            }
                        }
                    }
                    VStack{
                        HStack{
                            Text("\(listing?.carYear ?? "No Data") \(listing?.carMake ?? "No Data") \(listing?.carModel ?? "No Data") \(listing?.carType ?? "No Data")")
                                .font(.custom("Jost-Regular", size: 25))
                                .frame(maxWidth: 375, alignment: .leading)
                                .foregroundColor(Color.foreground)
                            Spacer()
                            Button(action: {
                                isLiked.toggle()
                                
                                Task{
                                    do{
                                        try await appendLikedUser(usersLiked: user ?? "", isLiked: isLiked, listingID: listing?.listingID ?? "")
                                    }catch {
                                        
                                    }
                                }
                            }, label: {
                                ZStack{
                                    Image(systemName: isLiked ? "heart.fill" : "heart")
                                        .resizable()
                                        .foregroundColor(.foreground)
                                        .frame(width:40, height:35)
                                }
                            })
                        }
                        Divider()
                        HStack{
                            WebImage(url: URL(string: userViewModel.photoURL))
                                .resizable()
                                .scaledToFill()
                                .frame(width:55, height:55)
                                .clipShape(Circle())
                            Text("\(userViewModel.displayName)")
                                .font(.custom("Jost-Regular", size: 20))
                                .foregroundColor(.foreground)
                            Spacer()
                        }
                        Text("\(listing?.carDescription ?? "No Data")")
                            .font(.custom("Jost-Regular", size: 20))
                            .foregroundColor(.foreground)
                            .frame(maxWidth: 375, alignment: .leading)
                            .multilineTextAlignment(.leading)
                        Text("Listed date")
                            .font(.custom("Jost-Regular", size: 20))
                            .foregroundColor(.gray)
                            .frame(maxWidth: 375, alignment: .leading)
                        RatingView(rating: $viewModel.rating)
                        Button {
                            reviewIsShown.toggle()
                        }label: {
                            Text("Leave a Review")
                                .font(.custom("Jost-Regular", size: 20))
                                .foregroundColor(.accentColor)
                                .frame(maxWidth: 375, alignment: .leading)
                        } .fullScreenCover(isPresented: $reviewIsShown) {
                            ReviewView(listing: listing, review: Review())
                        }
                        
                        }label: {
                            Text("Leave a Review")
                                .font(.custom("Jost-Regular", size: 20))
                                .foregroundColor(.accentColor)
                                .frame(maxWidth: 375, alignment: .leading)
                        } .fullScreenCover(isPresented: $reviewIsShown) {
                            ReviewView(listing: listing, review: Review())
                        }
                        
                    }
                }
                .onAppear{
                    viewModel.getRatings(listingID: (listing?.listingID)!)
                    if listing != nil {
                        Task {
                            do{
                                try await userViewModel.getUserInfo(listing: listing!)
                                user = try AuthenticationManager.shared.getAuthenticatedUser().uid
                                try await FirebaseManager.shared.firestore.collection("carListings").document((listing?.listingID)!).collection("usersClicked").document(user!).setData(["timeAccessed" : Date.now])
                                try await checkForLike()
                                

                            }catch {
                                print("error getting listing")
                            }
                        }
                    }
                }
            }.padding()

        }
    }
    
    func appendLikedUser(usersLiked: String, isLiked: Bool, listingID: String) async throws {
        let db = Firestore.firestore()
        let user = try AuthenticationManager.shared.getAuthenticatedUser().uid

        if isLiked == true {
            
            let usersLikedData = [
                "usersLiked": [usersLiked]
            ]
            
            try await FirebaseManager.shared.firestore.collection("carListings")
                .document((listing?.listingID)!).setData(usersLikedData, merge: true)
        }
        else {
            try await db.collection("carListings").document(listingID).updateData([
                    "usersLiked": FieldValue.arrayRemove([user])
                ])
        }
    }
    
    func checkForLike() async throws {
        @State var likedVehicles: [String] = []
        
        let db = Firestore.firestore()
        let user = try AuthenticationManager.shared.getAuthenticatedUser().uid
        
        do {
            let querySnapshot = try await db.collection("carListings").whereField("usersLiked", arrayContains: user)
                .getDocuments()
            for document in querySnapshot.documents {
                
                if listing?.listingID == document.documentID {
                    isLiked = true
                }
            }
        } catch {
            print("Error getting documents: \(error)")
        }
    }
//    func averageRating(ratingList: [Int]) {
//        print(ratingList)
//        var ratingTotal = 0
//        var unroundedRating = 0.0
//        for rating in ratingList {
//            ratingTotal += rating
//        }
//        unroundedRating = Double(ratingTotal / ratingList.count)
//        rating = round(unroundedRating * 10) / 10.0
//    }
}
#Preview {
    listingView(showSignInView: .constant(false))
}


