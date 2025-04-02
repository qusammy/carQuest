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
                ForEach(pendingList) {listing in
                    NavigationLink(destination: buyingListingView(showSignInView: $showSignInView, listing: listing)) {
                        VStack{
                            HStack{
                                Image(systemName: "exclamationmark.transmission")
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
                }
            }
        }
        .padding()
        .onAppear(){
            Task{
                do{
                    try viewModel.generateMyPendingListings()
                        
                } catch{
                
                }
            }
        }
        .onChange(of: viewModel.pendingVehicles) {
            pendingList = viewModel.pendingVehicles
        }
    }
}
