//  Created by Maddy Quinn on 9/30/24.
//
import SwiftUI
import Combine
import Firebase
import FirebaseFirestore
import FirebaseStorage
import SDWebImage
import SDWebImageSwiftUI

struct rentView: View {
    @StateObject var viewModel = ListingViewModel()
    @Binding var showSignInView: Bool
    @State var userPreferences = ""

    @Environment(\.presentationMode) var presentationMode
    @State var showListingScreen = false
    
    @State var shouldNavigateToListingView = false
    var body: some View {
        NavigationStack{
            VStack{
                topNavigationBar(showSignInView: $showSignInView)
                HStack{
                    Text("Rental services")
                        .foregroundColor(Color.foreground)
                        .font(.custom("ZingRustDemo-Base", size: 35))
                    Spacer()
                    NavigationLink(destination: listingCreation(carType: "", location: "", carModel: "", carMake: "", carDescription:"", showSignInView: $showSignInView).navigationBarBackButtonHidden(true)){
                            ZStack{
                                RoundedRectangle(cornerRadius: 20)
                                    .frame(width:125, height:35)
                                    .foregroundColor(Color("appColor"))
                                Text("List a Rental")
                                    .foregroundColor(.white)
                                    .font(.custom("Jost-Regular", size: 20))
                        }
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
                List(viewModel.rentListings) { listing in
                    ZStack(alignment: .center) {
                        Button{
                        print(viewModel.rentListings)
                        viewModel.listingFromList = viewModel.rentListings.firstIndex(of: listing) ?? 0
                            showListingScreen.toggle()
                    } label: {
                        imageBox(imageName: URL(string: listing.imageName!), carYear: listing.carYear ?? "", carMake: listing.carMake ?? "", carModel: listing.carModel ?? "", carType: listing.carType ?? "", width: 250, height: 250)
                    }
                        NavigationLink(destination: listingView(showSignInView: $showSignInView, listing: carListing()).opacity(0)){
                            // empty NavigationLink label to get rid of the arrows in the list
                           Text("Empty")
                        }.opacity(0.0)

                        }
                    }.foregroundStyle(Color.foreground)
                        .background(Color.background)
                        .listStyle(.inset)
                        .scrollContentBackground(.hidden)
                        .scrollIndicators(.hidden)
                        .listRowBackground(Color(.background))
                        .onAppear {
                            viewModel.generateRentListings()
                        }
                    bottomNavigationBar(showSignInView: $showSignInView)

                    }.padding()
        }.fullScreenCover(isPresented: $showListingScreen){
            listingView(showSignInView: $showSignInView, listing: carListing())
        }
    }
}

    
    
//    init(showSignInView: Binding<Bool>) {
//        self._showSignInView = showSignInView
//    }
    

//    func loadPhoto(imageName: String){
//        let storageRef = Storage.storage().reference()
//        let fileRef = storageRef.child(imageName)
//        var downloadFinished = false
//        var downloadStatus = ""
//        
//        
//        let downloadTask = fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
//            if error == nil && data != nil {
//                let image = UIImage(data: data!)
//            }
//            
//        }
//    }



//#Preview {
//    rentView(showSignInView: .constant(false))
//}
