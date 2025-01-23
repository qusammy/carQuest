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

    @State var isPresented = false
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
                            Text("Recently viewed")
                                .font(Font.custom("Jost-Regular", size:20))
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
                            Button(action: {
                                isPresented.toggle()
                            }, label: {
                                Text("See all")
                                    .font(Font.custom("Jost-Regular", size:15))
                                    .underline()
                            })
                           
                        }.padding(.horizontal, 10.0)
                        HStack{
                            carListingLink(showSignInView: $showSignInView, imageName: "carExample", text: "2019 Honda Civic Hatchback")
                            Spacer()
                            carListingLink(showSignInView: $showSignInView, imageName: "carExample", text: "2019 Honda Civic Hatchback")
                        }
                    }.padding()
                }
            }
        }
        .fullScreenCover(isPresented: $isPresented, content: {
            LikedVehiclesView(showSignInView: .constant(false))

            }
           
        )
        .onAppear{
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
struct LikedVehiclesView: View {
    @Binding var showSignInView: Bool
    
    @Environment(\.dismiss) var dismiss
    @State private var vehiclesLikedArray: [String] = []
    @StateObject var viewModel = ProfileViewModel()
    @StateObject var vm = ListingViewModel()
    
    
    
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                    dismiss()
                }, label: {
                    backButton()
                })
                
                Spacer()
            }
            ScrollView(showsIndicators: false){
                ForEach(vm.likedVehicles) { listing in
                    NavigationLink(destination: listingView(showSignInView: $showSignInView, listing: listing)) {
                        imageBox(imageName: URL(string: listing.imageName!), carYear: listing.carYear!, carMake: listing.carMake!, carModel: listing.carModel!, carType: listing.carType!, width: 200, height: 200)
                        Divider()
                    }
                }
            }
            //            ForEach(vehiclesLikedArray, id: \.self) { listing in
            //
            //
            //            }
            Spacer()
        }
        .padding()
        .onAppear(){
            Task{
                do{
                    try vm.generateLikedListings()
                }catch {
                    
                }
            }
            //            Task{
            //                do {
            //                    await appendLikedVehicles()
            //                }
            //            }
        }
    }
}
//    func appendLikedVehicles() async{
//        let db = Firestore.firestore()
//        let docRef = db.collection("carListings")
//
//        do{
//            let query = try await docRef.whereField("usersLiked", arrayContains: AuthenticationManager.shared.getAuthenticatedUser().uid).getDocuments()
//            for document in query.documents {
//                vehiclesLikedArray.append(document.documentID)
//                print(vehiclesLikedArray)
//            }
//        } catch{
//            
//        }
//    }
//    func fetchLikedVehicles(){
//        Firestore.firestore().collection("carListings").whereField("usersLiked", isEqualTo: AuthenticationManager.shared.getAuthenticatedUser().uid).getDocuments() {snapshot, error in
//            if error == nil && snapshot != nil {
//                likedVehicles = snapshot!.documents.map { doc in
//                    
//                    return carListing(id: doc.documentID, carDescription: doc["carDescrpition"] as? String ?? "", carMake: doc["carMake"] as? String ?? "", carModel: doc["carModel"] as? String ?? "", carType: doc["carType"] as? String ?? "", carYear: doc["carYear"] as? String ?? "", userID: doc["userID"] as? String ?? "", imageName: doc["imageName"] as? String ?? "", listingType: doc["listingType"] as? String ?? "", listingID: doc["listingID"] as? String ?? "", usersLiked: doc["usersLiked"] as? [String] ?? [""])
//                    
//                }
//            }
//        }
//}

