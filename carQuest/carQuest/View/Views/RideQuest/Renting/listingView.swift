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
    @Environment(\.dismiss) var dismiss

    @State private var isLiked: Bool = false
    @Binding var showSignInView: Bool
    @StateObject var viewModel = ListingViewModel()
    @StateObject var userViewModel = UserInfoViewModel()
    @State var listing: carListing?
    @State var user: String?
    @State private var reviewIsShown: Bool = false
    @State private var rating: Double = 0.0
    @State private var editIsPresented: Bool = false
    @State private var showingDeleteAlert: Bool = false
    @State private var profileViewIsPresented: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack{
                if listing?.userID == user {
                    Button{
                        editIsPresented.toggle()
                    }label: {
                        ZStack{
                            
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width:125, height:35)
                                .foregroundColor(Color("appColor"))
                            Text("Edit")
                                .foregroundColor(.white)
                                .font(.custom("Jost-Regular", size: 20))
                        }
                    } .fullScreenCover(isPresented: $editIsPresented) {
                        listingCreation(carType: listing?.carType ?? "", location: "", carModel: listing?.carModel ?? "", carMake: listing?.carMake ?? "", listingPrice: "", carDescription: listing?.carDescription ?? "", listingLetter: "R", showSignInView: $showSignInView, selection: 2)
                    }
                    
                    Button {
                        showingDeleteAlert = true
                    }label: {
                        Text("Delete")
                            .font(Font.custom("Jost-Regular", size: 20))
                            .foregroundColor(.accentColor)
                    }.alert("Are you sure you want to delete this listing?", isPresented: $showingDeleteAlert) {
                        Button(role: .destructive) {
                            Task {
                                do{
                                    try await Firestore.firestore().collection("carListings").document((listing?.listingID)!).delete()
                                    dismiss()
                                }catch {
                                    
                                }
                            }
                            
                        }label: {
                            Text("Delete Listing")
                                .font(Font.custom("Jost-Regular", size: 20))
                        }
                    }message: {
                        Text("This action cannot be undone. \n The info on this listing will be unrecoverable.")
                    }
                }
                ScrollView(showsIndicators: false){
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
                        Button {
                            profileViewIsPresented.toggle()
                        } label: {
                            WebImage(url: URL(string: userViewModel.photoURL))
                                .resizable()
                                .scaledToFill()
                                .frame(width:55, height:55)
                                .clipShape(Circle())
                            Text("\(userViewModel.displayName)")
                                .font(.custom("Jost-Regular", size: 20))
                                .foregroundColor(.foreground)
                        }
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
                        }
                        HStack{
                            Text("\(listing?.carDescription ?? "No Data")")
                                .font(.custom("Jost-Regular", size: 20))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.leading)
                                .lineLimit(4)
                            Spacer()
                        }
                        HStack{
                            Text("Listed on \(listing?.dateCreated ?? Date(), format: .dateTime.day().month().year())")
                                .font(.custom("Jost-Regular", size: 18))
                                .foregroundColor(Color(.init(white:0.65, alpha:1)))
                                .frame(alignment: .leading)
                            Spacer()
                        }
                        HStack{
                            Text("$\(listing?.listingPrice ?? "000.00") per day")
                                .font(.custom("Jost-Regular", size: 22))
                                .foregroundColor(.foreground)
                            Spacer()
                            Button(action: {
                                //brings up message view
                            }, label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 15)
                                        .frame(width: 65, height: 35)
                                        .foregroundColor(Color("appColor"))
                                    Text("Book")
                                        .font(.custom("Jost-Regular", size:20))
                                        .foregroundColor(.white)
                                }
                            })
                        }
                        Divider()
                        .fullScreenCover(isPresented: $reviewIsShown) {
                            ReviewView(listing: listing, review: Review())
                        }
                        VStack{
                            Spacer()
                            if viewModel.reviews.isEmpty {
                                VStack{
                                    Text("There are no reviews for this vehicle yet.")
                                        .font(.custom("Jost-Regular", size: 20))
                                        .foregroundColor(.foreground)
                                    Button {
                                        reviewIsShown.toggle()
                                    }label: {
                                        Text("Write a Review")
                                            .font(.custom("Jost-Regular", size: 20))
                                            .foregroundColor(.accentColor)
                                    }
                                }
                            } else {
                                VStack{
                                    HStack{
                                        RatingView(rating: $viewModel.rating, width: 30, height:30)
                                        Spacer()
                                        Text("\(viewModel.rating) stars")
                                            .font(.custom("Jost", size: 15))
                                            .foregroundColor(Color(.init(white:0.65, alpha:1)))
                                            .multilineTextAlignment(.trailing)
                                    }
                                    Button {
                                        reviewIsShown.toggle()
                                    }label: {
                                        HStack{
                                            Text("Write a Review")
                                                .font(.custom("Jost-Regular", size: 20))
                                                .foregroundColor(.accentColor)
                                            Spacer()
                                        }
                                    }
                                    ForEach(viewModel.reviews) { review in
                                        VStack{
                                            HStack {
                                                ReviewPod(userImage: URL(string: review.userImage), width: 30 , height: 30, textSize: 20, userName: review.userName, title: review.title, textBody: review.body, rating: Double(review.rating))
                                                Spacer()
                                            }
                                            Divider()
                                        }
                                    }
                                }
                            }
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
            }
            .padding()
            .fullScreenCover(isPresented: $profileViewIsPresented, content: {
                OtherProfileView(username: userViewModel.displayName, profilePic: userViewModel.photoURL, description: userViewModel.description, userID: listing?.userID ?? "", showSignInView: $showSignInView)
            })
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


