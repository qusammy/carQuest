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
    

    var body: some View {
        NavigationStack{
            VStack{
                ScrollView{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            imageBox(imageName: URL(string: listing?.imageName ?? "4.png"), width: 300, height: 275)
                            Image("carQuestLogo")
                                .resizable()
                                .frame(width:300, height:275)
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
                        Text((listing?.listingType) ?? "No Data")
                            .font(.custom("Jost-Regular", size:17))
                            .foregroundColor(.foreground)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: 375, alignment: .leading)
                        Text("\(listing?.carDescription ?? "Description")")
                            .font(.custom("Jost-Regular", size: 20))
                            .foregroundColor(.foreground)
                            .frame(maxWidth: 375, alignment: .leading)
                            .multilineTextAlignment(.leading)
                        Text("Listed date")
                            .font(.custom("Jost-Regular", size: 20))
                            .foregroundColor(.gray)
                            .frame(maxWidth: 375, alignment: .leading)
                        
                    }
                }
                .onAppear{
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
}
#Preview {
    listingView(showSignInView: .constant(false))
}


