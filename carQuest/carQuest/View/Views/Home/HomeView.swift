import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseAnalytics
import Combine
import SDWebImageSwiftUI

struct HomeView: View {
    
    static var isAlreadyLaunchedOnce = false // Used to avoid 2 FIRApp configure
    @Binding var showSignInView: Bool
    
    @StateObject private var viewModel = SignInEmailViewModel()
    @StateObject var viewModel2 = ListingViewModel()
    @State var date: Date = Date()
    @State var user = ""
    
    @State var isPresented = false
    @State var isPresented2 = false
    @State var isPresented3 = false
    @State private var shuffledList: [carListing] = [carListing]()
    @State private var shuffledList1: [carListing] = [carListing]()
    @State private var shuffledList2: [carListing] = [carListing]()
    
    var body: some View {
        NavigationStack {
            Spacer()
                .navigationBarBackButtonHidden(true)
            ScrollView(showsIndicators: false){
                VStack{
                    HStack {
                        if viewModel.displayName == "" {
                            Text("Welcome, user!")
                                .font(Font.custom("Jost", size:30))
                                .foregroundColor(Color("Foreground"))
                        }else {
                            Text("Welcome, \(viewModel.displayName)!")
                                .font(Font.custom("Jost", size:30))
                                .foregroundColor(Color("Foreground"))
                        }
                    }
                    Divider()
                    VStack{
                        HStack{
                            Text("Liked Vehicles")
                                .font(Font.custom("Jost-Regular", size:20))
                            Spacer()
                            Button(action: {
                                isPresented.toggle()
                            }, label: {
                                Text("See all")
                                    .font(Font.custom("Jost-Regular", size:15))
                                    .underline()
                            })
                        }
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack{
                                Spacer()
                                ForEach(shuffledList2) { listing in
                                    if listing.listingType == "auction" {
                                        NavigationLink(destination: AuctionListingView(showSignInView: $showSignInView, listing: listing)) {
                                            imageBox(imageName: URL(string: listing.imageName![0]), carYear: listing.carYear, carMake: listing.carMake, carModel: listing.carModel, carType: listing.carType, width: 100, height: 100, textSize: 10)
                                        }
                                    }
                                    else if listing.listingType == "renting" {
                                        NavigationLink(destination: listingView(showSignInView: $showSignInView, listing: listing)) {
                                            imageBox(imageName: URL(string: listing.imageName![0]), carYear: listing.carYear!, carMake: listing.carMake!, carModel: listing.carModel!, carType: listing.carType!, width: 100, height: 100, textSize: 10)
                                        }.frame(width:115)
                                    }
                                    else {
                                        
                                    }
                                }
                            }
                        }
                        Divider()
                        VStack{
                            HStack{
                                Text("Recently Viewed")
                                    .font(Font.custom("Jost-Regular", size:20))
                                Spacer()
                                Button(action: {
                                    isPresented2.toggle()
                                }, label: {
                                    Text("See all")
                                        .font(Font.custom("Jost-Regular", size:15))
                                        .underline()
                                })
                            }
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack{
                                    Spacer()
                                    ForEach(shuffledList1) { listing in
                                        NavigationLink(destination: listingView(showSignInView: $showSignInView, listing: listing)) {
                                            imageBox(imageName: URL(string: listing.imageName![0]), carYear: listing.carYear!, carMake: listing.carMake!, carModel: listing.carModel!, carType: listing.carType!, width: 100, height: 100, textSize: 10)
                                        }.frame(width:115)
                                    }
                                }
                            }
                        }
                        
                        Divider()
                        VStack{
                            HStack{
                                Text("New")
                                    .font(Font.custom("Jost-Regular", size:20))
                                Spacer()
                                Button(action: {
                                    isPresented3.toggle()
                                }, label: {
                                    Text("See all")
                                        .font(Font.custom("Jost-Regular", size:15))
                                        .underline()
                                })
                            }
                            ScrollView(.horizontal, showsIndicators: false){
                                HStack{
                                    ForEach(shuffledList.prefix(5)) { listing in
                                        if listing.dateCreated! >= Calendar.current.date(byAdding: .month, value: -1, to: Date.now)! {
                                            NavigationLink(destination: listingView(showSignInView: $showSignInView, listing: listing)) {
                                                imageBox(imageName: URL(string: listing.imageName![0]), carYear: listing.carYear!, carMake: listing.carMake!, carModel: listing.carModel!, carType: listing.carType!, width: 100, height: 100, textSize: 10)
                                            }.frame(width:115)
                                        }
                                    }
                                }
                            }
                        }
                    }.padding()
                }
                .fullScreenCover(isPresented: $isPresented, content: {
                    LikedVehiclesView(showSignInView: .constant(false))
                })
                .fullScreenCover(isPresented: $isPresented2, content: {
                    RecentlyViewedView(showSignInView: .constant(false))
                })
                .fullScreenCover(isPresented: $isPresented3, content: {
                    NewListingsView(showSignInView: .constant(false))
                })
                
                .onAppear{
                    viewModel2.generateAllListings()
                    viewModel2.generateUsersClicked()
                    Task {
                        do {
                            try viewModel2.generateLikedListings()
                            
                        }catch {
                            
                        }
                    }
                    if FirebaseApp.app() == nil {
                        FirebaseApp.configure()
                    }
                }
                
                .onChange(of: viewModel2.allListings) {
                    shuffledList = viewModel2.allListings.shuffled()
                }
                .onChange(of: viewModel2.recentListings) {
                    shuffledList1 = viewModel2.recentListings.shuffled()
                }
                .onChange(of: viewModel2.likedVehicles) {
                    shuffledList2 = viewModel2.likedVehicles.shuffled()
                    
                }
                
                .navigationViewStyle(StackNavigationViewStyle())
                .task {
                    viewModel.getDisplayName()
                }
            }
            
            
        }
        
    }
}
