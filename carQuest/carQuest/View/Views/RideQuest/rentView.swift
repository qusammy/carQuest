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
    @State private var creationIsPresented: Bool = false
    @State private var listingIsPresented: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack{
                topNavigationBar(showSignInView: $showSignInView)
                HStack{
                    Text("Rental services")
                        .foregroundColor(Color.foreground)
                        .font(.custom("ZingRustDemo-Base", size: 35))
                    Spacer()
                    Button{
                        creationIsPresented.toggle()
                    }label: {
                        ZStack{
                            
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width:125, height:35)
                                .foregroundColor(Color("appColor"))
                            Text("List a Rental")
                                .foregroundColor(.white)
                                .font(.custom("Jost-Regular", size: 20))
                        }
                    } .fullScreenCover(isPresented: $creationIsPresented) {
                        listingCreation(carType: "", location: "", carModel: "", carMake: "", carDescription: "", showSignInView: $showSignInView)
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
                        Button{
                            listingIsPresented.toggle()
                        }label: {
                            imageBox(imageName: URL(string: listing.imageName!), carYear: listing.carYear ?? "", carMake: listing.carMake ?? "", carModel: listing.carModel ?? "", carType: listing.carType ?? "", width: 250, height: 250)
                        }.fullScreenCover(isPresented: $listingIsPresented) {
                            listingView(showSignInView: $showSignInView, listing: listing)
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
            }
            
        }.foregroundStyle(Color.foreground)
            .background(Color.background)
            .scrollContentBackground(.hidden)
            .listRowBackground(Color(.background))
            .onAppear {
                viewModel.generateRentListings()
            }
        
        bottomNavigationBar(showSignInView: $showSignInView)
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
