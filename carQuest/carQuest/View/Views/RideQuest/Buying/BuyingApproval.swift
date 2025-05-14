//
//  BuyingApproval.swift
//  carQuest
//
//  Created by Maddy Quinn on 4/4/25.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct BuyingApproval: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var isLiked: Bool = false
    @State private var status: String = "For sale"
    @ObservedObject var viewModel = ListingViewModel()
    @ObservedObject var userViewModel = UserInfoViewModel()
    @StateObject var chatVM = UserProfileViewModel()
    @State var listing: carListing?
    @State var user: String?
    @State private var reviewIsShown: Bool = false
    @State private var rating: Double = 0.0
    @State private var editIsPresented: Bool = false
    @State private var showingDeleteAlert: Bool = false
    @State private var reviews = [Review]()
    @State private var isPresentingOtherProfileView: Bool = false
    @State private var showAlert = false
    @State private var chatUser: CarQuestUser?

    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    Text("Vehicle purchased")
                        .foregroundStyle(Color.foreground)
                        .font(.custom("ZingRustDemo-Base", size: 40))
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(Color.accentColor)
                            .font(.custom("Jost", size: 20))
                            .underline()
                    }
                }
                ScrollView{
                    HStack{
                        Image("carQuestLogo")
                            .resizable()
                            .frame(width:100, height:100)
                        Spacer()
                        Text("\(listing?.carYear ?? "error") \(listing?.carMake ?? "error") \(listing?.carModel ?? "error") \(listing?.carType ?? "error")")
                            .foregroundStyle(Color.foreground)
                            .font(.custom("Jost", size: 25))
                    }
                    HStack{
                        Text("Final price: $\(listing?.listingPrice ?? "error")")
                            .foregroundStyle(Color.foreground)
                            .font(.custom("Jost", size: 25))
                        Spacer()
                    }
                    HStack{
                        WebImage(url: URL(string: userViewModel.photoURL))
                            .resizable()
                            .scaledToFill()
                            .frame(width:75, height:75)
                            .clipShape(Circle())
                        Text(userViewModel.displayName)
                            .foregroundStyle(Color.foreground)
                            .font(.custom("Jost", size: 23))
                        Spacer()
                        NavigationLink(destination: ChatView(carUser: chatUser) ,label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 25)
                                    .frame(width:125, height:30)
                                    .foregroundStyle(Color.accentColor)
                                Text("Message")
                                    .font(.custom("Jost", size: 20))
                                    .foregroundStyle(Color.white)
                            }
                        })
                    }
                    .onAppear {
                        chatUser = chatVM.getUser(uid: (listing?.userID)!)
                    }
                    HStack{
                        Text("Manage Approval")
                            .foregroundStyle(Color.foreground)
                            .font(.custom("Jost", size: 25))
                        Spacer()
                    }
                    HStack{
                        Button {
                            showAlert = true
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 25)
                                    .frame(width:125, height:50)
                                    .foregroundStyle(Color.accentColor)
                                Text("Approve")
                                    .font(.custom("Jost", size: 23))
                                    .foregroundStyle(Color.white)
                            }
                        }
                        Spacer()
                        Button {
                            // Does not approve listing. Changes "status" in Firebase.
                            // status: "pending" -> "listed"
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 25)
                                    .frame(width:125, height:50)
                                    .foregroundStyle(Color.foreground)
                                Text("Disapprove")
                                    .font(.custom("Jost", size: 23))
                                    .foregroundStyle(Color.white)
                            }
                        }
                    }
                }
                Spacer()
                Text("If you believe a user is attempting to scam or troll you, please go to their profile to report them.")
                    .foregroundStyle(Color.gray)
                    .font(.custom("Jost", size: 15))
                    .multilineTextAlignment(.center)
            }
            .alert("Are you sure you want to approve of the purchase of this vehicle?", isPresented: $showAlert) {
        Button(role: .destructive) {
                Task {
                    do {
                        try await approveStatus(docID: listing?.listingID ?? "")
                    }catch {
                        print(error)
                            }
                        }
                }label: {
                    Text("Approve")
                }
            }
            .padding()
        }
    }
    func approveStatus(docID: String) async throws {
        let db = Firestore.firestore()
        let user = try AuthenticationManager.shared.getAuthenticatedUser().uid
        let docRef = db.collection("carListings").document(docID)

        do {
          try await docRef.updateData([
            "status": "approved"
          ])
        } catch {
        }
    }
}

#Preview {
    BuyingApproval()
}
