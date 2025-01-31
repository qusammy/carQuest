//
//  RideModel.swift
//  carQuest
//
//  Created by beraoud_981215 on 9/13/24.
//

import Foundation
import Firebase
import SwiftUI

struct LikedVehiclesView: View {
    @Binding var showSignInView: Bool
    
    @Environment(\.dismiss) var dismiss
    @State private var vehiclesLikedArray: [String] = []
    @StateObject var viewModel = ProfileViewModel()
    @StateObject var vm = ListingViewModel()
    
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    Text("Liked Vehicles")
                        .font(Font.custom("ZingRustDemo-Base", size: 35))
                        .foregroundStyle(Color.foreground)
                    Spacer()
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("Cancel")
                            .font(.custom("Jost-Regular", size: 17))
                            .foregroundStyle(Color.accentColor)
                            .underline()
                    })
                }
                
                ScrollView(showsIndicators: false){
                    ForEach(vm.likedVehicles) { listing in
                        VStack{
                            NavigationLink(destination: listingView(showSignInView: $showSignInView, listing: listing)) {
                                imageBox(imageName: URL(string: listing.imageName!), carYear: listing.carYear!, carMake: listing.carMake!, carModel: listing.carModel!, carType: listing.carType!, width: 200, height: 200)
                            }
                        }
                    }
                    Spacer()
                    Text("Your liked vehicles will appear here.")
                        .foregroundColor(Color(.init(white:0.65, alpha:1)))
                        .multilineTextAlignment(.center)
                        .font(.custom("Jost-Regular", size: 17))
                }.foregroundStyle(Color.foreground)
                Spacer()
            }
        }
        .padding()
        .onAppear(){
            Task{
                do{
                    try vm.generateLikedListings()
                }catch {
                    
                }
            }
        }
    }
}

struct RecentlyViewedView: View {
    @Binding var showSignInView: Bool
    
    @Environment(\.dismiss) var dismiss
    @State private var vehiclesLikedArray: [String] = []
    @StateObject var viewModel = ProfileViewModel()
    @StateObject var vm = ListingViewModel()
    
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    Text("Recently Viewed")
                        .font(Font.custom("ZingRustDemo-Base", size: 35))
                        .foregroundStyle(Color.foreground)
                    Spacer()
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("Cancel")
                            .font(.custom("Jost-Regular", size: 17))
                            .foregroundStyle(Color.accentColor)
                            .underline()
                    })
                }
                ScrollView(showsIndicators: false){
                    ForEach(vm.recentListings) { listing in
                        VStack{
                            NavigationLink(destination: listingView(showSignInView: $showSignInView, listing: listing)) {
                                imageBox(imageName: URL(string: listing.imageName!), carYear: listing.carYear!, carMake: listing.carMake!, carModel: listing.carModel!, carType: listing.carType!, width: 200, height: 200)
                            }
                        }
                    }
                    Spacer()
                    Text("Your recently viewed vehicles will appear here.")
                        .foregroundColor(Color(.init(white:0.65, alpha:1)))
                        .multilineTextAlignment(.center)
                        .font(.custom("Jost-Regular", size: 17))
                }.foregroundStyle(Color.foreground)
                Spacer()
            }
        }
        .padding()
        //        .onAppear(){
        //            Task{
        //                do{
        //                  //  try vm.generateUsersClicked() }
        //                catch { }
        //            }
        //        }
        //    }
    }
}
