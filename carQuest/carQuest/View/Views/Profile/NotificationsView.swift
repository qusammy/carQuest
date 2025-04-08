import SwiftUI
import Firebase

struct NotificationsView: View {
    @State var notificationAlert: Bool = true
    @State var notifications: [String] = [""]
    @State var message: String = "Not changed"
    @StateObject private var viewModel = ListingViewModel()
    @State private var pendingList: [carListing] = [carListing]()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack{
            HStack{
                Text("Notifications")
                    .font(Font.custom("ZingRustDemo-Base", size: 40))
                    .foregroundColor(Color.foreground)
                Spacer()
                }
            ScrollView{
                if pendingList != [carListing]() {
                    ForEach(pendingList) {listing in
                        if listing.listingType == "buying" {
                            NavigationLink(destination: buyingListingView(showSignInView: $showSignInView, listing: listing)) {
                                VStack{
                                    HStack{
                                        Image(systemName: "dollarsign")
                                            .resizable()
                                            .frame(width:20, height:30)
                                            .foregroundStyle(Color.accentColor)
                                        VStack{
                                            HStack{
                                                Text("Vehicle pending")
                                                    .font(.custom("Jost", size: 20))
                                                    .foregroundStyle(Color.foreground)
                                                Spacer()
                                            }
                                            HStack{
                                                Text("\(listing.listingTitle ?? "") has been bought and is waiting for your approval.")
                                                    .font(.custom("Jost", size: 16))
                                                    .foregroundStyle(Color.foreground)
                                                    .multilineTextAlignment(.leading)
                                                Spacer()
                                            }
                                        }
                                    }
                                    Divider()
                                }
                            }
                        } else if listing.listingType == "auction" {
                            NavigationLink(destination: AuctionListingView(showSignInView: $showSignInView, listing: listing)) {
                                VStack{
                                    HStack{
                                        Image(systemName: "building.columns.fill")
                                            .resizable()
                                            .frame(width:30, height:30)
                                            .foregroundStyle(Color.accentColor)
                                        VStack{
                                            HStack{
                                                Text("Vehicle pending")
                                                    .font(.custom("Jost", size: 20))
                                                    .foregroundStyle(Color.foreground)
                                                Spacer()
                                            }
                                            HStack{
                                                Text("\(listing.listingTitle ?? "") has been bought out and is waiting for your approval.")
                                                    .font(.custom("Jost", size: 16))
                                                    .foregroundStyle(Color.foreground)
                                                    .multilineTextAlignment(.leading)
                                                Spacer()
                                            }
                                        }
                                    }
                                    Divider()
                                }
                            }
                        }
                    }
                } else if pendingList == [carListing]() {
                        Text("No new notifications.")
                            .font(Font.custom("Jost", size: 20))
                            .foregroundColor(Color.foreground)
                }
            }
        }
        .padding()
        .onAppear(){
            Task{
                do{
                    try viewModel.generateMyPendingBuyingListings()
                    try viewModel.generateMyPendingAuctionListings()

                } catch{
                
                }
            }
        }
        .onChange(of: viewModel.pendingVehicles) {
            pendingList = viewModel.pendingVehicles
        }
        .onChange(of: viewModel.pendingVehicles) {
            pendingList = viewModel.pendingVehicles
        }
    }
}
