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
    @State private var shuffledList: [carListing] = [carListing]()
    @State private var searchTerm = ""
    var filteredList: [carListing] {
        guard !searchTerm.isEmpty else {return shuffledList}
        return shuffledList.filter {$0.carModel!.localizedCaseInsensitiveContains(searchTerm)}
    }
    
    @State var shouldNavigateToListingView = false
    var body: some View {
        NavigationStack {
            VStack{
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
                        listingCreation(carType: "", location: "", carModel: "", carMake: "", carDescription: "", listingLetter: "R", showSignInView: $showSignInView, selection: 2)
                    }
                }
                
                ScrollView(showsIndicators: false){
                    ForEach(filteredList) { listing in
                        NavigationLink(destination: listingView(showSignInView: $showSignInView, listing: listing)) {
                            imageBox(imageName: URL(string: listing.imageName![0]), carYear: listing.carYear!, carMake: listing.carMake!, carModel: listing.carModel!, carType: listing.carType!, width: 250, height: 250, textSize: 20)
                        }
                    }
                }.foregroundStyle(Color.foreground)
                    .task {
                        DispatchQueue.main.async {
                            viewModel.generateRentListings()
                            shuffledList = viewModel.rentListings.shuffled()
                        }
                    }
                
            }.padding()
                .task {
                    viewModel.generateRentListings()
                }
        }
    }
    
}


#Preview {
    rentView(showSignInView: .constant(false))
}
