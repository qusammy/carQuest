//
//  SettingsViews.swift
//  carQuest
//
//  Created by Maddy Quinn on 12/11/24.
//

import Foundation
import SwiftUI

struct NavigateToSetting: View {
    
    @State var destination: AnyView
    @State var shouldNavigateToSettingView: Bool = false
    @State var title: String
    
    var body: some View {
        VStack{
            NavigationLink(destination: destination, isActive: $shouldNavigateToSettingView) {
                Text(title)
                    .font(.custom("Jost-Regular", size: 20))
                    .foregroundColor(Color.foreground)
            }
        }
    }
}

struct PushNotificationView: View {
    // to exit view
    @Binding var showSignInView: Bool

    // to toggle button
    @State var pushNotification: Bool = true
    var body: some View {
        VStack{
            ScrollView(showsIndicators: false){
                HStack{
                    Text("Push Notifications")
                        .font(Font.custom("ZingRustDemo-Base", size: 40))
                        .foregroundColor(Color.foreground)
                    Spacer()
                    }
                    Toggle(isOn: $pushNotification) {
                        Text("Enable push notifications")
                            .font(Font.custom("Jost-Regular", size: 20))
                            .foregroundColor(Color.foreground)
                    }.toggleStyle(SwitchToggleStyle(tint: .accentColor))
                    Spacer()
                Divider()
            }.padding()
        }
    }
}

struct MyListingsView: View {
    
    @Binding var showSignInView: Bool
    @StateObject private var viewModel = ListingViewModel()
    

    var body: some View {
        ScrollView{
            VStack{
                HStack{
                    Text("My Listings")
                        .font(Font.custom("ZingRustDemo-Base", size: 40))
                        .foregroundColor(Color.foreground)
                    Spacer()
                }
                HStack{
                    Text("Auction")
                        .font(Font.custom("Jost", size: 30))
                        .foregroundStyle(Color.foreground)
                    Spacer()
                }
                if viewModel.myauctionListings.isEmpty {
                    HStack{
                        Text("No auction listings.")
                            .font(Font.custom("Jost", size: 15))
                            .foregroundColor(Color(red: 0.723, green: 0.717, blue: 0.726))
                        Spacer()
                    }
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack{
                        Spacer()
                        ForEach(viewModel.myauctionListings) { listing in
                            NavigationLink(destination: listingView(showSignInView: $showSignInView, listing: listing)) {
                                imageBox(imageName: URL(string: listing.imageName![0]), carYear: listing.carYear!, carMake: listing.carMake!, carModel: listing.carModel!, carType: listing.carType!, width: 100, height: 100, textSize: 10)
                            }
                        }
                        Spacer()
                    }
                }
                .task{
                    do{
                        try viewModel.generateMyAuctionListings()
                    }catch {
                        
                    }
                }
                Divider()
                HStack{
                    Text("Renting")
                        .font(Font.custom("Jost", size: 30))
                        .foregroundStyle(Color.foreground)
                    Spacer()
                }
                if viewModel.myrentListings.isEmpty {
                    HStack{
                        Text("No rental listings.")
                            .font(Font.custom("Jost", size: 15))
                            .foregroundColor(Color(red: 0.723, green: 0.717, blue: 0.726))
                        Spacer()
                    }
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack{
                        ForEach(viewModel.myrentListings) { listing in
                            NavigationLink(destination: listingView(showSignInView: $showSignInView, listing: listing)) {
                                imageBox(imageName: URL(string: listing.imageName![0]), carYear: listing.carYear!, carMake: listing.carMake!, carModel: listing.carModel!, carType: listing.carType!, width: 100, height: 100, textSize: 10)
                            }
                        }
                    }
                }
                .task{
                    do{
                        try viewModel.generateMyRentListings()
                    }catch {
                        
                    }
                }
                Divider()
                HStack{
                    Text("Buying")
                        .font(Font.custom("Jost", size: 30))
                        .foregroundStyle(Color.foreground)
                    Spacer()
                }
                if viewModel.mybuyListings.isEmpty {
                    HStack{
                        Text("No vehicles for sale.")
                            .font(Font.custom("Jost", size: 15))
                            .foregroundColor(Color(red: 0.723, green: 0.717, blue: 0.726))
                        Spacer()
                    }
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack{
                        ForEach(viewModel.mybuyListings) { listing in
                            NavigationLink(destination: listingView(showSignInView: $showSignInView, listing: listing)) {
                                imageBox(imageName: URL(string: listing.imageName![0]), carYear: listing.carYear!, carMake: listing.carMake!, carModel: listing.carModel!, carType: listing.carType!, width: 100, height: 100, textSize: 10)
                            }
                        }
                    }
                }
                .task{
                    do{
                        try viewModel.generateMyBuyListings()
                    }catch {
                        
                    }
                }
            }.padding()
        }
    }
}

struct AboutCarQuest: View {
    @Binding var showSignInView: Bool

    var body: some View {
        ScrollView{
            VStack{
                HStack{
                    Text("About Car Quest")
                        .font(Font.custom("ZingRustDemo-Base", size: 40))
                        .foregroundColor(Color.foreground)
                    Spacer()
                }
               Text("Hi")
            }.padding()
        }
    }
}

struct PrivacyView: View {
    @Binding var showSignInView: Bool
    
    var body: some View {
        ScrollView{
            VStack{
                HStack{
                    Text("Privacy")
                        .font(Font.custom("ZingRustDemo-Base", size: 40))
                        .foregroundColor(Color.foreground)
                    Spacer()
                }
            }.padding()
        }
    }
}

struct PurchasesView: View {
    
    @Binding var showSignInView: Bool

    var body: some View {
            ScrollView{
                VStack{
                    HStack{
                        Text("Purchases & Payment")
                            .font(Font.custom("ZingRustDemo-Base", size: 40))
                            .foregroundColor(Color.foreground)
                        Spacer()
                    }
                }.padding()
            }
        }
    }

