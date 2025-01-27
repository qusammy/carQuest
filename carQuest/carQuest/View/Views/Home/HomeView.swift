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
    var body: some View {
        NavigationStack {
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
                    VStack{
                        HStack{
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
                    }
                    Spacer()
                }
                VStack{
                    HStack{
                        Text("Liked vehicles")
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
                            ForEach(viewModel2.likedVehicles) { listing in
                                NavigationLink(destination: listingView(showSignInView: $showSignInView, listing: listing)) {
                                    HStack{
                                        imageBox(imageName: URL(string: listing.imageName!), carYear: listing.carYear!, carMake: listing.carMake!, carModel: listing.carModel!, carType: listing.carType!, width: 100, height: 100,    textSize: 10)
                                    }
                                }
                            }
                        }
                    }
                    Spacer()
                }
            }.padding()
        } .fullScreenCover(isPresented: $isPresented, content: {
            LikedVehiclesView(showSignInView: .constant(false))
        })
        .onAppear{
            viewModel2.generateAllListings()
            viewModel2.generateUsersClicked()
            
            Task {
                do {
                    user = try AuthenticationManager.shared.getAuthenticatedUser().uid
                    try viewModel2.generateLikedListings()
                    
                }catch {
                    
                }
            }
            if FirebaseApp.app() == nil {
                FirebaseApp.configure()
            }
        }
        
        .navigationViewStyle(StackNavigationViewStyle())
        .task {
            viewModel.getDisplayName()
        }
    }
}
#Preview {
    HomeView(showSignInView: .constant(false))
}
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
                    Button(action: {
                        dismiss()
                    }, label: {
                        backButton()
                    })
                    Text("Liked Vehicles")
                        .font(Font.custom("ZingRustDemo-Base", size: 30))
                        .foregroundStyle(Color.foreground)
                    Spacer()
                }
                
                ScrollView(showsIndicators: false){
                    ForEach(vm.likedVehicles) { listing in
                        VStack{
                            NavigationLink(destination: listingView(showSignInView: $showSignInView, listing: listing)) {
                                imageBox(imageName: URL(string: listing.imageName!), carYear: listing.carYear!, carMake: listing.carMake!, carModel: listing.carModel!, carType: listing.carType!, width: 200, height: 200)
                            }
                        }
                    }
                }.foregroundStyle(Color.foreground)
                Spacer()
            }
//            }.toolbar{
//                ToolbarItem(placement: .principal){
//                    Text("Liked Vehicles")
//                        .font(Font.custom("ZingRustDemo-Base", size: 30))
//                        .foregroundStyle(Color.foreground)
//                }
//            }
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

