import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
import SDWebImageSwiftUI

struct AuctionListingView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var isLiked: Bool = false
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
    @State private var status: String = "For auction"
    @State private var showAlert = false

    var body: some View {
        NavigationStack{
            VStack{
                ScrollView(showsIndicators: false){
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            ForEach((listing?.imageName)!, id: \.self) { image in
                                WebImage(url: URL(string: image))
                                    .resizable()
                                    .frame(width:300, height:300)
                            }
                        }
                    }.toolbar{
                        ToolbarItem(placement: .principal){
                            VStack{
                                if (listing?.endTime!)! <= Date.now {
                                    Text("Current Bid: $\(listing?.currentBid ?? "No Bids") \(Image(systemName: "clock.fill")) Ended")
                                        .background(Color.gray)
                                        .font(.custom("Jost-Regular", size: 17))
                                        .foregroundColor(Color.white)
                                        .lineLimit(1)
                                        .multilineTextAlignment(.leading)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                        .padding()
                                }
                                else {
                                    let range = Date.now...(listing?.endTime!)!
                                    let diffComponents = Calendar.current.dateComponents([.day], from: Date.now, to: (listing?.endTime!)!)
                                    let days = diffComponents.day
                                    if days! >= 1 {
                                        Text(" Bid: $\(listing?.currentBid ?? "No Bids")   \(Image(systemName: "clock.fill"))   \(diffComponents.day!) days ")
                                            .background(Color.gray)
                                            .font(.custom("Jost-Regular", size: 17))
                                            .foregroundColor(Color.white)
                                            .lineLimit(1)
                                            .multilineTextAlignment(.leading)
                                            .clipShape(RoundedRectangle(cornerRadius: 5))
                                            .padding()
                                    }
                                    else {
                                        Text(" Current Bid: $\(listing?.currentBid ?? "No Bids")   \(Image(systemName: "clock.fill")) Time Left:  \(Text(timerInterval: range, countsDown: true)) ")
                                            .background(Color.accentColor)
                                            .font(.custom("Jost-Regular", size: 17))
                                            .foregroundColor(Color.white)
                                            .lineLimit(1)
                                            .multilineTextAlignment(.leading)
                                            .clipShape(RoundedRectangle(cornerRadius: 5))
                                            .padding()
                                    }
                                }
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
                        if listing?.userID == user {
                            HStack{
                                Button{
                                    editIsPresented.toggle()
                                }label: {
                                    Text("Edit")
                                        .foregroundColor(.accentColor)
                                        .font(.custom("Jost-Regular", size: 20))
                                    
                                } .fullScreenCover(isPresented: $editIsPresented) {
                                    AuctionCreation(editListing: true, carType: listing?.carType ?? "", location: listing?.location ?? "", carModel: listing?.carModel ?? "", carMake: listing?.carMake ?? "", carDescription: listing?.carDescription ?? "", startBid: listing?.startBid ?? "", buyout: listing?.buyout ?? "", endTime: listing?.endTime ?? Date(), showSignInView: $showSignInView)
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
                            Text("\(listing?.carDescription ?? "No Data")")
                                .font(.custom("Jost-Regular", size: 20))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.leading)
                                .lineLimit(4)
                            Spacer()
                        }
                        HStack{
                            VStack{
                                Text(listing?.location ?? "No Data")
                                    .font(.custom("Jost-Regular", size: 20))
                                    .foregroundColor(Color(.init(white:0.65, alpha:1)))
                                    .frame(alignment: .leading)
                                Text("Last edited on \(listing?.dateCreated ?? Date(), format: .dateTime.day().month().year())")
                                    .font(.custom("Jost-Regular", size: 20))
                                    .foregroundColor(Color(.init(white:0.65, alpha:1)))
                                    .frame(alignment: .leading)
                                Spacer()
                            }
                        }
                        Divider()
                        VStack {
                            HStack {
                                Text("Stater Bid: $\(listing?.startBid ?? "000.00")")
                                    .font(.custom("Jost-Regular", size: 22))
                                    .foregroundColor(.foreground)
                                Text("Current Bid: $\(listing?.currentBid ?? "000.00")")
                                    .font(.custom("Jost-Regular", size: 22))
                                    .foregroundColor(.foreground)
                                Button {
                                    Task {
                                        do {
                                            try await checkForBid()
                                        }catch {
                                            
                                        }
                                    }
                                }label: {
                                    Image(systemName: "arrow.clockwise")
                                        .frame(width: 22, height: 22)
                                        .foregroundStyle(Color.accentColor)
                                }
                                Spacer()
                                if listing?.userID != user && status == "For auction"{
                                    Button(action: {
                                        //brings up payment view
                                    }, label: {
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 15)
                                                .frame(width: 85, height: 35)
                                                .foregroundColor(Color("appColor"))
                                            Text("Place Bid")
                                                .font(.custom("Jost-Regular", size:20))
                                                .foregroundColor(.white)
                                        }
                                    })
                                } else if listing?.userID != user && status != "For auction"{
                                    
                                }
                            }
                            HStack{
                                Text("$\(listing?.listingPrice ?? "000.00")")
                                    .font(.custom("Jost-Regular", size: 22))
                                    .foregroundColor(.foreground)
                                Spacer()
                                if status == "For auction" && listing?.userID != user {
                                    Button(action: {
                                        showAlert = true
                                        
                                    }, label: {
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 15)
                                                .frame(width: 135, height: 35)
                                                .foregroundColor(Color("appColor"))
                                            Text("Buyout auction")
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
                        }
                        Divider()
                        VStack{
                            Spacer()
                            if viewModel.reviews.isEmpty {
                                Text("There are no reviews for this vehicle yet.")
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
                            } else {
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
                                    Text("Leave a Review")
                                        .font(.custom("Jost-Regular", size: 20))
                                        .foregroundColor(.accentColor)
                                } .fullScreenCover(isPresented: $reviewIsShown) {
                                    ReviewView(listing: listing, review: Review())
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
            
                .onAppear {
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
            .alert("Are you sure you want to buyout this vehicle?", isPresented: $showAlert) {
        Button(role: .destructive) {
                Task {
                    do {
                        try await statusPending(docID: listing?.listingID ?? "")
                    }catch {
                        print(error)
                            }
                        }
                }label: {
                    Text("Buyout")
                }
            }
            .padding()
                .onChange(of: viewModel.reviews) {
                    reviews = viewModel.reviews.shuffled()
                }
                .task {
                    Task {
                        do {
                            try await checkForBid()
                        }catch {
                            
                        }
                    }
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
            print("Error getting documents: \(error)")
        }
    }
    
    func checkForBid() async throws{
        let document = try await Firestore.firestore().collection("carListings").document((listing?.listingID!)!).getDocument()
        if document.exists {
            let startBid = Double(listing?.startBid ?? "0.0")
            let newBid = Double(document.get("currentBid") as? String ?? "0.0")
            let oldBid = Double(listing?.currentBid ?? "0.0")
            let biggest = [newBid!, oldBid!, startBid!].max() ?? 0.0
            if newBid == biggest {
                listing?.currentBid = document.get("currentBid") as? String ?? ""
            }
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
}

#Preview {
    AuctionListingView(showSignInView: .constant(false))
}
