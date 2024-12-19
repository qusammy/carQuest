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

struct listingView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var isLiked: Bool = false
    @State private var likeTapped: Bool = false
    @Binding var showSignInView: Bool
    @StateObject var viewModel = ListingViewModel()
    @StateObject var userViewModel = UserInfoViewModel()
    @State var listing: carListing?
    
    
    var body: some View {
        VStack{
            //ui customizable
            Button {
                dismiss()
            }label: {
                Text("Back")
            }
            ScrollView{
                imageBox(imageName: URL(string: listing?.imageName ?? "4.png"), width: 250, height: 250)
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
                        }).offset(x:-40)
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
                        Button(action: {
                            isLiked.toggle()
                        }, label: {
                            ZStack{
                                Image(systemName: isLiked ? "heart.fill" : "heart")
                                    .resizable()
                                    .foregroundColor(.foreground)
                                    .frame(width:40, height:35)
                            }
                        }).offset(x:40)
                    }
                    HStack {
                        Text("Year: \(listing?.carYear ?? "No Data")")
                            .font(.custom("Jost-Regular", size: 25))
                            .frame(maxWidth: 375, alignment: .leading)
                            .foregroundColor(.foreground)
                        Text("Make: \(listing?.carMake ?? "No Data")")
                            .font(.custom("Jost-Regular", size: 25))
                            .frame(maxWidth: 375, alignment: .leading)
                            .foregroundColor(.foreground)
                        Text("Model: \(listing?.carModel ?? "No Data")")
                            .font(.custom("Jost-Regular", size: 25))
                            .frame(maxWidth: 375, alignment: .leading)
                            .foregroundColor(.foreground)
                        Text("Type: \(listing?.carType ?? "No Data")")
                            .font(.custom("Jost-Regular", size: 25))
                            .frame(maxWidth: 375, alignment: .leading)
                            .foregroundColor(.foreground)
                    }
                    HStack{
                        Image("\(userViewModel.photoURL)")
                            .resizable()
                            .frame(width:55, height:55)
                        Text("\(userViewModel.displayName)")
                            .font(.custom("Jost-Regular", size: 20))
                            .foregroundColor(.foreground)
                            .frame(maxWidth: 375, alignment: .leading)
                    }
                    Text("Description: \(listing?.carDescription ?? "No Data")")
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
                viewModel.generateRentListings()
                if viewModel.rentListings.count > 0 && viewModel.listingFromList < viewModel.rentListings.count {
                    listing = viewModel.rentListings[viewModel.listingFromList]
                    print("\(listing?.carYear ?? "uh oh")")
                }else {
                    print("fail")
                }
            }
        }
    }
}
#Preview {
    listingView(showSignInView: .constant(false))
}
