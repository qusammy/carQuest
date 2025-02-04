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
    @State var searchText: String
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
                        listingCreation(carType: "", location: "", carModel: "", carMake: "", listingPrice: "", carDescription: "", listingLetter: "R", showSignInView: $showSignInView, selection: 2)
                    }
                }
                HStack{
                    Image(systemName: "list.bullet.circle.fill")
                        .resizable()
                        .foregroundColor(Color.accentColor)
                        .frame(width:30, height:30)
                    Spacer()
                    HStack{
                        Image(systemName: "magnifyingglass.circle.fill")
                            .resizable()
                            .frame(width:30, height:30)
                            .foregroundColor(Color.accentColor)
                        TextField("Search for a dream car...", text: $searchText)
                            .frame(width:200, height:30)
                            .font(.custom("Jost-Regular", size: 18))
                           
                    }
                }
                ScrollView(showsIndicators: false){
                    ForEach(shuffledList.filter({ searchText.isEmpty ? true : $0.listingTitle!.localizedCaseInsensitiveContains(searchText) })) { listing in
                        
                        NavigationLink(destination: listingView(showSignInView: $showSignInView, listing: listing)) {
                            
                            imageBox(imageName:URL(string: listing.imageName![0]), carYear: listing.carYear!, carMake: listing.carMake!, carModel: listing.carModel!, carType: listing.carType!, width: 250, height: 250, textSize: 22)
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
    rentView(showSignInView: .constant(false), searchText: "")
}
