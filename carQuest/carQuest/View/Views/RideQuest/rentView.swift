//  Created by Maddy Quinn on 9/30/24.
//
import SwiftUI
import Combine
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct rentView: View {
    @ObservedObject var viewModel = ListingViewModel()
    @Binding var showSignInView: Bool
    @State private var retrievedImages = [UIImage]()
    
    
    var body: some View {
        NavigationView{
            VStack{
                Spacer()
                topNavigationBar(showSignInView: $showSignInView)
                NavigationLink(destination: listingCreation(carType: "", location: "", carModel: "", carMake: "", carDescription:"", showSignInView: $showSignInView).navigationBarBackButtonHidden(true)){
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width:220, height:50)
                            .foregroundColor(Color("appColor"))
                        Text("List a Rental")
                            .foregroundColor(.white)
                            .font(.custom("Jost-Regular", size: 30))
                    }
                }
                List(viewModel.allListings) { listing in
                    if listing.listingType == "renting" {
                        ForEach(retrievedImages, id: \.self) { image in
                            NavigationLink(destination: listingView(showSignInView: $showSignInView)) {
                                imageBox(imageName: image, carYear: listing.carYear, carMake: listing.carMake, carModel: listing.carModel, width: 250, height: 250)
                                viewModel.listingIndex = viewModel.allListings.firstIndex(of: listing)
                            }
                        }
                    }
                }.foregroundStyle(Color.foreground)
                    .background(Color.background)
                    .scrollContentBackground(.hidden)
                    .listRowBackground(Color(.background))
                
                bottomNavigationBar(showSignInView: $showSignInView)
            }.frame(width:375)
                .onAppear {
                    loadPhotos()
                    viewModel.generateListings()
                }
        }
    }
    init(showSignInView: Binding<Bool>) {
        self._showSignInView = showSignInView
    }

    
    func loadPhotos() {
        let db = Firestore.firestore()
        db.collection("carListings").whereField("listingType", isEqualTo: "renting").getDocuments { snapshot, error in
            if error == nil && snapshot != nil {
                var paths = [String]()
                
                for document in snapshot!.documents {
                    paths.append(document["imageName"] as! String)
                }
                
                for path in paths {
                    let storageRef = Storage.storage().reference()
                    let fileRef = storageRef.child(path)
                    
                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                        if error == nil && data != nil {
                            if let image = UIImage(data: data!) {
                                    retrievedImages.append(image)
                            }
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    rentView(showSignInView: .constant(false))
}
