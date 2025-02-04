//
//  AuctionView.swift
//  carQuest
//
//  Created by Maddy Quinn on 11/8/24.
//

import SwiftUI

struct AuctionView: View {
    @Binding var showSignInView: Bool
    @State var userPreferences = ""
    @State private var creationIsPresented: Bool = false
    @StateObject private var vm = ListingViewModel()
    
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    Text("Auction services")
                        .foregroundColor(Color.foreground)
                        .font(.custom("ZingRustDemo-Base", size: 35))
                    Spacer()
                    Button{
                        creationIsPresented.toggle()
                    }label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width:135, height:35)
                                .foregroundColor(Color("appColor"))
                            Text("Auction a car")
                                .foregroundColor(.white)
                                .font(.custom("Jost-Regular", size: 20))
                        }
                    } .fullScreenCover(isPresented: $creationIsPresented) {
                        listingCreation(carType: "", location: "", carModel: "", carMake: "", listingPrice: "", carDescription: "", listingLetter: "A", showSignInView: $showSignInView, selection: 1)
                    }
                }
                    HStack{
                        Image(systemName: "list.bullet.circle.fill")
                            .resizable()
                            .foregroundColor(Color.accentColor)
                            .frame(width:30, height:30)
                        Spacer()
                        Button(action: {
                            
                        }, label: {
                            Image(systemName: "magnifyingglass.circle.fill")
                                .resizable()
                                .foregroundColor(Color.accentColor)
                                .frame(width:30, height:30)
                        })
                        TextField("Search for a dream car...", text: $userPreferences)
                            .frame(width:200, height:30)
                            .font(.custom("Jost-Regular", size: 18))
                    }
                ScrollView{
                    Divider()
                    HStack{
                        //carBox elements will go here. links to auction view in separate HStack lines! still being built
                        NavigationLink(destination: AuctionListingView(showSignInView: $showSignInView, bid: "")){
                            VStack{
                                Image("carQuestLogo")
                                    .resizable()
                                    .frame(width: 150, height: 150)
                                Text("Car for auction")
                                    .foregroundColor(.black)
                                    .font(Font.custom("Jost-Regular", size: 20))
                            }
                        }
                    }
                }
            }
        }.frame(width:375)
    }
}

#Preview {
    AuctionView(showSignInView: .constant(false))
}
