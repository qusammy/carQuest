import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct buyingListingView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var isLiked: Bool = false
    @State private var status: String = "For sale"
    @Binding var showSignInView: Bool
    @ObservedObject var viewModel = ListingViewModel()
    @ObservedObject var userViewModel = UserInfoViewModel()
    @State var listing: carListing?
    @State var user: String?
    @State private var reviewIsShown: Bool = false
    @State private var rating: Double = 0.0
    @State private var editIsPresented: Bool = false
    @State private var showingDeleteAlert: Bool = false
    @State private var reviews = [Review]()
    @State private var isPresentingOtherProfileView: Bool = false
    @State private var showAlert = false

    var body: some View {
        NavigationStack{
            VStack{
                ScrollView(showsIndicators: false){
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            if listing?.imageName?.isEmpty != nil{
                                ForEach((listing?.imageName)!, id: \.self) { image in
                                    WebImage(url: URL(string: image))
                                        .resizable()
                                        .frame(width:300, height:300)
                                }
                            } else {
                                WebImage(url: URL(string: "https://firebasestorage.googleapis.com/v0/b/carquest-4038a.appspot.com/o/4.png?alt=media&token=d79fb423-974c-4b7c-87ac-0dd495ab66e5"))
                            }
                        }
                    }
                    VStack{
                        Group{
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
                        }
                        if listing?.userID == user {
                            HStack{
                                Button{
                                    editIsPresented.toggle()
                                }label: {
                                    Text("Edit")
                                        .foregroundColor(.accentColor)
                                        .font(.custom("Jost-Regular", size: 20))
                                    
                                } .fullScreenCover(isPresented: $editIsPresented) {
                                    listingCreation(editListing: false, carType: listing?.carType ?? "", location: "", carModel: listing?.carModel ?? "", carMake: listing?.carMake ?? "", carYear: listing?.carYear ?? "", listingPrice: "", carDescription: listing?.carDescription ?? "", listingLetter: "R", showSignInView: $showSignInView, selection: 2, modifications: "")
                                }
                                Spacer()
                                Button {
                                    showingDeleteAlert = true
                                }label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 15)
                                            .frame(width:110, height:35)
                                            .foregroundColor(Color("appColor"))
                                        HStack{
                                            Text("Delete")
                                                .font(Font.custom("Jost-Regular", size: 20))
                                                .foregroundColor(.white)
                                            Image(systemName: "trash.fill")
                                                .resizable()
                                                .frame(width:20, height:25)
                                                .foregroundStyle(.white)
                                        }
                                    }
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
                        }
                        Divider()
                        HStack{
                        Button {
                            isPresentingOtherProfileView.toggle()
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
                        .fullScreenCover(isPresented: $isPresentingOtherProfileView, content: {
                            OtherProfileView(username: userViewModel.displayName, profilePic: userViewModel.photoURL, description: userViewModel.description, userID: listing?.userID ?? "", showSignInView: $showSignInView, reportReason: "")
                        })

                        Spacer()
                            if listing?.userID != user {
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
                        }
                        HStack{
                            Text(listing?.location ?? "No Data")
                                .font(.custom("Jost-Regular", size: 20))
                                .foregroundColor(Color.foreground)
                                .frame(alignment: .leading)
                            Spacer()
                        }
                        HStack{
                            Text("\(listing?.carDescription ?? "No Data")")
                                .font(.custom("Jost-Regular", size: 20))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.leading)
                                .lineLimit(4)
                            Spacer()
                            }
                        Divider()
                        HStack{
                            Text("Mileage")
                                .font(.custom("Jost-Regular", size: 20))
                                .foregroundColor(.gray)
                            Spacer()
                            Text(listing?.carMileage ?? "")
                                .font(.custom("Jost-Regular", size: 20))
                                .foregroundColor(.gray)
                        }
                        HStack{
                            Text("Title")
                                .font(.custom("Jost-Regular", size: 20))
                                .foregroundColor(.gray)
                            Spacer()
                            Text(listing?.carTitle ?? "")
                                .font(.custom("Jost-Regular", size: 20))
                                .foregroundColor(.gray)
                        }
                        HStack{
                            Text("Last edited on \(listing?.dateCreated ?? Date(), format: .dateTime.day().month().year())")
                                .font(.custom("Jost-Regular", size: 20))
                                .foregroundColor(Color(.init(white:0.65, alpha:1)))
                                .frame(alignment: .leading)
                            Spacer()
                        }
                            
                        Divider()
                        HStack{
                            Text("$\(listing?.listingPrice ?? "000.00")")
                                .font(.custom("Jost-Regular", size: 22))
                                .foregroundColor(.foreground)
                            Spacer()
                            if status == "For sale" && listing?.userID != user {
                                Button(action: {
                                    showAlert = true
                                    
                                }, label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 15)
                                            .frame(width: 100, height: 35)
                                            .foregroundColor(Color("appColor"))
                                        Text("Purchase")
                                            .font(.custom("Jost-Regular", size:20))
                                            .foregroundColor(.white)
                                    }
                                })
                                
                            } else if status == "pending" && listing?.userID != user {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 15)
                                        .frame(width: 100, height: 35)
                                        .foregroundStyle(Color.gray)
                                    Text("Pending")
                                        .font(.custom("Jost-Regular", size:20))
                                        .foregroundColor(.white)
                                    
                                }
                            }
                        }
                        Divider()
                        VStack{
                            Spacer()
                            if viewModel.reviews.isEmpty {
                                Text("There are no reviews for this seller yet.")
                                    .font(.custom("Jost-Regular", size: 20))
                                    .foregroundColor(.foreground)
                                Button {
                                    reviewIsShown.toggle()
                                }label: {
                                    Text("Leave a Review")
                                        .font(.custom("Jost-Regular", size: 20))
                                        .foregroundColor(.accentColor)
                                } .fullScreenCover(isPresented: $reviewIsShown) {
                                    ReviewView(listing: listing, review: Review())
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
                                try await checkStatus()
                                
                            }catch {
                                print("error getting listing")
                            }
                        }
                    }
                }

            }
            .alert("Are you sure you want to purchase this vehicle?", isPresented: $showAlert) {
        Button(role: .destructive) {
                Task {
                    do {
                        try await statusPending(docID: listing?.listingID ?? "")
                        try await checkStatus()
                    }catch {
                        print(error)
                            }
                        }
                }label: {
                    Text("Purchase")
                }
            }
            .padding()
            .onChange(of: viewModel.reviews) {
                reviews = viewModel.reviews.shuffled()
            }
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
        }
    }
    
    func statusPending(docID: String) async throws {
        let db = Firestore.firestore()
        let user = try AuthenticationManager.shared.getAuthenticatedUser().uid
        let docRef = db.collection("carListings").document(docID)

        do {
          try await docRef.updateData([
            "status": "pending"
          ])
        } catch {
        }
    }
    
    func checkStatus() async throws {
        
        let db = Firestore.firestore()
        let user = try AuthenticationManager.shared.getAuthenticatedUser().uid
        
        do {
            let querySnapshot = try await db.collection("carListings").whereField("status", isEqualTo: "pending")
                .getDocuments()
            for document in querySnapshot.documents {
                
                if listing?.listingID == document.documentID {
                    status = "pending"
                }
            }
        } catch {
        }
    }
}


#Preview {
    buyingListingView(showSignInView: .constant(false))
}


