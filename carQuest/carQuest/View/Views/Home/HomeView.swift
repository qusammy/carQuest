import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseAnalytics
import Combine
struct HomeView: View {
    
    static var isAlreadyLaunchedOnce = false // Used to avoid 2 FIRApp configure
    @Binding var showSignInView: Bool
    
    @StateObject private var viewModel = SignInEmailViewModel()
    @StateObject var viewModel2 = ListingViewModel()
    @State var date: Date = Date()
    @State var user = ""
    
    var body: some View {
        
        NavigationView {
            VStack {
                Spacer()
                    .navigationBarBackButtonHidden(true)
                ScrollView(showsIndicators: false){
                    VStack{
                        HStack {
                            if viewModel.displayName == "" {
                                Text("Welcome, $displayname!")
                                    .font(Font.custom("Jost", size:30))
                                    .foregroundColor(Color("Foreground"))
                            }else {
                                Text("Welcome, \(viewModel.displayName)!")
                                    .font(Font.custom("Jost", size:30))
                                    .foregroundColor(Color("Foreground"))
                            }
                        }
                        Divider()
                        HStack{
                            VStack {
                                Text("Recently viewed")
                                    .font(Font.custom("Jost-Regular", size:20))
                                ScrollView(.horizontal, showsIndicators: false){
                                    HStack{
                                        Spacer()
                                        ForEach(viewModel2.recentListings) { listing in
                                            NavigationLink(destination: listingView(showSignInView: $showSignInView, listing: listing)) {
                                                imageBox(imageName: URL(string: listing.imageName!), carYear: listing.carYear!, carMake: listing.carMake!, carModel: listing.carModel!, carType: listing.carType!, width: 100, height: 100, textSize: 10)
                                            }
                                            
                                        }
                                    }
                                }
                            }
                            Spacer()
                            Text("See all")
                                .font(Font.custom("Jost-Regular", size:15))
                                .underline()
                        }.padding(.horizontal, 10.0)
                        HStack{
                            
                        }
                        HStack{
                            carListingLink(showSignInView: $showSignInView, imageName: "carExample", text: "2019 Honda Civic Hatchback")
                            Spacer()
                            carListingLink(showSignInView: $showSignInView, imageName: "carExample", text: "2019 Honda Civic Hatchback")
                        }
                        Divider()
                        HStack{
                            Text("Liked vehicles")
                                .font(Font.custom("Jost-Regular", size:20))
                            Spacer()
                            Text("See all")
                                .font(Font.custom("Jost-Regular", size:15))
                                .underline()
                        }.padding(.horizontal, 10.0)
                        HStack{
                            carListingLink(showSignInView: $showSignInView, imageName: "carExample", text: "2019 Honda Civic Hatchback")
                            Spacer()
                            carListingLink(showSignInView: $showSignInView, imageName: "carExample", text: "2019 Honda Civic Hatchback")
                        }
                    }.padding()
                }
            }
        }.onAppear{
            viewModel2.generateAllListings()
            viewModel2.generateUsersClicked()
            Task {
                do {
                    user = try AuthenticationManager.shared.getAuthenticatedUser().uid
                }catch {
                    
                }
            }
            if FirebaseApp.app() == nil {
                FirebaseApp.configure()
            }
        }.navigationViewStyle(StackNavigationViewStyle())
            .task {
                viewModel.getDisplayName()
            }
    }
    
    
}
#Preview {
    HomeView(showSignInView: .constant(false))
}

