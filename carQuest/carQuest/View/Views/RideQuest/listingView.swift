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
    @State private var isLiked: Bool = false
    @State private var likeTapped: Bool = false
    @Binding var showSignInView: Bool
    @ObservedObject var viewModel = ListingViewModel()
    @StateObject var userViewModel = UserInfoViewModel()
    @State private var listing: carListing = carListing()

    
    var body: some View {
        VStack{
            ScrollView{
                        imageBox(imageName: URL(string: listing.imageName ?? "4.png"), width: 250, height: 250)
                VStack{
                    HStack{
                        Button(action: {
                            //brings up booking view
                        }, label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 80, height: 35)
                                    .foregroundColor(.black)
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
                                    .foregroundColor(.black)
                                    .frame(width:40, height:35)
                            }
                        }).offset(x:40)
                    }
                    HStack {
                        Text("Year: \(listing.carYear ?? "No Data")")
                            .font(.custom("Jost-Regular", size: 25))
                            .frame(maxWidth: 375, alignment: .leading)
                            .foregroundColor(.black)
                        Text("Make: \(listing.carMake ?? "No Data")")
                            .font(.custom("Jost-Regular", size: 25))
                            .frame(maxWidth: 375, alignment: .leading)
                            .foregroundColor(.black)
                        Text("Model: \(listing.carModel ?? "No Data")")
                            .font(.custom("Jost-Regular", size: 25))
                            .frame(maxWidth: 375, alignment: .leading)
                            .foregroundColor(.black)
                        Text("Type: \(listing.carType ?? "No Data")")
                            .font(.custom("Jost-Regular", size: 25))
                            .frame(maxWidth: 375, alignment: .leading)
                            .foregroundColor(.black)
                    }
                    .task{
                        viewModel.generateRentListings()
                            if viewModel.rentListings.count > 0 && viewModel.listingFromList < viewModel.rentListings.count {
                                listing = viewModel.rentListings[viewModel.listingFromList]
                                print("\(listing.carYear ?? "uh oh")")
                            }
                        }
                        HStack{
                            Image("\(userViewModel.photoURL)")
                                .resizable()
                                .frame(width:55, height:55)
                            Text("\(userViewModel.displayName)")
                                .font(.custom("Jost-Regular", size: 20))
                                .foregroundColor(.black)
                                .frame(maxWidth: 375, alignment: .leading)
                        }
                    Text("Description: \(listing.carDescription ?? "No Data")")
                            .font(.custom("Jost-Regular", size: 20))
                            .foregroundColor(.black)
                            .frame(maxWidth: 375, alignment: .leading)
                            .multilineTextAlignment(.leading)
                        Text("Listed date")
                            .font(.custom("Jost-Regular", size: 20))
                            .foregroundColor(.gray)
                            .frame(maxWidth: 375, alignment: .leading)

                }
            }
        }
    }
}
#Preview {
    listingView(showSignInView: .constant(false))
}
