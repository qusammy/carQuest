//
//  OtherProfileView.swift
//  carQuest
//
//  Created by Maddy Quinn on 2/14/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct OtherProfileView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var username: String
    @State var profilePic: String
    @State var description: String
    @State var userID: String
    @StateObject var viewModel = ListingViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        NavigationStack{
            ScrollView(showsIndicators: false){
                    HStack{
                        WebImage(url: URL(string: profilePic))
                            .resizable()
                            .resizable()
                            .scaledToFill()
                            .frame(width:65, height:65)
                            .clipShape(Circle())
                        Text(username)
                            .foregroundStyle(Color.foreground)
                            .font(Font.custom("ZingRustDemo-Base", size: 35))
                        Spacer()
                    }
                    HStack{
                        Text(description)
                            .foregroundColor(.gray)
                            .font(Font.custom("Jost-Regular", size: 20))
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Divider()
                    HStack{
                        Text("\(username)'s listings")
                            .foregroundStyle(Color.foreground)
                            .font(Font.custom("ZingRustDemo-Base", size: 25))
                        Spacer()
                    }
                    if viewModel.userRentListings.isEmpty {
                        HStack{
                            Text("No rentals")
                                .foregroundColor(.gray)
                                .font(Font.custom("Jost-Regular", size: 20))
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    } else {
                        HStack{
                            Text("Rentals")
                                .foregroundStyle(Color.foreground)
                                .font(Font.custom("Jost-Regular", size: 20))
                            Spacer()
                        }
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack{
                                Spacer()
                                ForEach(viewModel.userRentListings) { listing in
                                    NavigationLink(destination: listingView(showSignInView: $showSignInView, listing: listing)) {
                                        imageBox(imageName: URL(string: listing.imageName![0]), carYear: listing.carYear!, carMake: listing.carMake!, carModel: listing.carModel!, carType: listing.carType!, width: 150, height: 150, textSize: 15)
                                    }.frame(width:165)
                                }
                                Spacer()
                            }
                        }
                    }
                    Divider()
                    if viewModel.userRentListings.isEmpty {
                        HStack{
                            Text("No auctions")
                                .foregroundColor(.gray)
                                .font(Font.custom("Jost-Regular", size: 20))
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    } else {
                        HStack{
                            Text("Auctions")
                                .foregroundStyle(Color.foreground)
                                .font(Font.custom("Jost-Regular", size: 20))
                            Spacer()
                        }
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack{
                                
                            }
                        }
                    }
                    Divider()
                    if viewModel.userRentListings.isEmpty {
                        HStack{
                            Text("No listings for sale")
                                .foregroundColor(.gray)
                                .font(Font.custom("Jost-Regular", size: 20))
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    } else {
                        HStack{
                            Text("For sale")
                                .foregroundStyle(Color.foreground)
                                .font(Font.custom("Jost-Regular", size: 20))
                            Spacer()
                        }
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack{
                                
                            }
                        }
                    }
                
            }       
            .padding()
            .toolbar{
                ToolbarItem(placement: .principal) {
                    HStack{
                        HStack{
                            Button(action: {
                                dismiss()
                            }, label: {
                                backButton()
                            })
                            Spacer()
                        }
                        Button(action: {
                            
                        }, label: {
                            Image(systemName: "exclamationmark.octagon")
                                .resizable()
                                .foregroundColor(Color.accentColor)
                                .frame(width:30, height:30)
                        })
                    }
                }
            }
        }
        .onAppear(){
            Task{
                do{
                    try viewModel.generateUserRentListings(userID: userID)
                } catch{ }
            }
        }
    }
}

#Preview {
    OtherProfileView(username: "", profilePic: "", description: "", userID: "", showSignInView: .constant(false))
}
