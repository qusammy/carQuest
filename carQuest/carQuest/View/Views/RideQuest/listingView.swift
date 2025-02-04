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
    @State private var likeTapped: Bool = false
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
                Text((listing?.listingType) ?? "No Data")
                    .font(.custom("Jost-Regular", size:35))
                    .foregroundColor(.foreground)
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
                            Button(action: {
                                //brings up booking view
                            }, label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 15)
                                        .frame(width: 80, height: 35)
                                        .foregroundColor(.foreground)
                                    Text("Book")
                                        .font(.custom("Jost-Regular", size:20))
                                        .foregroundColor(.white)
                                }
                            })
                            Spacer()
                            Button(action: {
                                //brings up message view
                            }, label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 15)
                                        .frame(width: 160, height: 35)
                                        .foregroundColor(Color("appColor"))
                                    Text("Send a Message")
                                        .font(.custom("Jost-Regular", size:20))
                                        .foregroundColor(.white)
                                }
                            })
                            Spacer()
//                            if listing?.usersLiked != nil && listing?.usersLiked.contains(AuthenticationManager.shared.getAuthenticatedUser())
                      //      if listing?.usersLiked.contains("2") {
                                
                            //}
                            Button(action: {
                                isLiked.toggle()
                                Task{
                                    do{
                                        try await appendLikedUser(usersLiked: user ?? "")
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
                        HStack {
                            Text("\(listing?.carYear ?? "No Data") \(listing?.carMake ?? "No Data") \(listing?.carModel ?? "No Data") \(listing?.carType ?? "No Data")")
                                .font(.custom("Jost-Regular", size: 25))
                                .frame(maxWidth: 375, alignment: .leading)
                                .foregroundColor(Color.foreground)
                        }
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
                                try await appendLikedUser(usersLiked: user ?? "")

                            }catch {
                                print("error getting listing")
                            }
                        }
                    }
                }
            }.padding()

        }
    }
    func appendLikedUser(usersLiked: String) async throws {
        let user = try AuthenticationManager.shared.getAuthenticatedUser().uid
        
        let usersLikedData = [
            "usersLiked": [usersLiked]
        ]
        
        try await FirebaseManager.shared.firestore.collection("carListings")
            .document((listing?.listingID)!).setData(usersLikedData, merge: true)
        
        
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


