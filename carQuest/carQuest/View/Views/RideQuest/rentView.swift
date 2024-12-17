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
    @ObservedObject var viewModel = ListingViewModel()
    @Binding var showSignInView: Bool
    @State var userPreferences = ""
    
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
                
                List(viewModel.rentListings) { listing in

                    NavigationLink(destination: listingView(showSignInView: $showSignInView)) {
                        Button{
                            print(viewModel.rentListings)
                            viewModel.listingFromList = viewModel.rentListings.firstIndex(of: listing) ?? 0
                        }label: {
                            imageBox(imageName: URL(string: listing.imageName!), carYear: listing.carYear ?? "", carMake: listing.carMake ?? "", carModel: listing.carModel ?? "", width: 250, height: 250)
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
            }.frame(width:375)
        }
    }
    
    init(showSignInView: Binding<Bool>) {
        self._showSignInView = showSignInView
    }
    

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
}


//#Preview {
//    rentView(showSignInView: .constant(false))
//}
