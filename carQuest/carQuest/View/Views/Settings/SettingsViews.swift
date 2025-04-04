import Foundation
import SwiftUI
import Firebase

struct NavigateToSetting: View {
    
    @State var destination: AnyView
    @State var shouldNavigateToSettingView: Bool = false
    @State var title: String
    
    var body: some View {
        VStack{
            NavigationLink(destination: destination, isActive: $shouldNavigateToSettingView) {
                Text(title)
                    .font(.custom("Jost-Regular", size: 20))
                    .foregroundColor(Color.foreground)
            }
        }
    }
}

struct PushNotificationView: View {
    // to exit view
    @Binding var showSignInView: Bool

    // to toggle button
    @State var pushNotification: Bool = true
    var body: some View {
        VStack{
            HStack{
                Text("Push Notifications")
                    .font(Font.custom("ZingRustDemo-Base", size: 40))
                    .foregroundColor(Color.foreground)
                Spacer()
                }
            ScrollView(showsIndicators: false){
                    Toggle(isOn: $pushNotification) {
                        Text("Enable push notifications")
                            .font(Font.custom("Jost-Regular", size: 20))
                            .foregroundColor(Color.foreground)
                    }.toggleStyle(SwitchToggleStyle(tint: .accentColor))
                    .padding()
                    Spacer()
                Divider()
            }.padding()
        }
    }
}
struct ConnectionsView: View {
    
    @Binding var showSignInView: Bool
    @State private var instagramEditor = false
    @State private var facebookEditor = false


    var body: some View {
                VStack{
                    HStack{
                        Text("Connections")
                            .font(Font.custom("ZingRustDemo-Base", size: 40))
                            .foregroundColor(Color.foreground)
                        Spacer()
                    }
                    List{
                        NavigationLink(destination: AddInstagramView(), isActive: $instagramEditor) {
                            Text("Instagram")
                                .font(.custom("Jost-Regular", size:20))
                                .foregroundColor(Color.foreground)
                                .lineLimit(1)
                        }
                        NavigationLink(destination: AddFacebookView(), isActive: $facebookEditor) {
                            Text("Facebook")
                                .font(.custom("Jost-Regular", size:20))
                                .foregroundColor(Color.foreground)
                                .lineLimit(1)
                        }

                    }.listStyle(.plain)
                }.padding()
            }
        }
struct AddInstagramView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm = UserProfileViewModel()
    
    @State var userInstagram: String = ""
    @State var instagram: String = ""
    var body: some View {
        VStack{
            HStack{
                Text("Add your Instagram")
                    .font(Font.custom("ZingRustDemo-Base", size: 40))
                    .foregroundColor(Color.foreground)
                Spacer()
                }
            
            TextField("Instagram", text: $userInstagram)
                    .font(Font.custom("Jost-Regular", size: 25))
                    .foregroundColor(Color.foreground)
                    .textFieldStyle(.roundedBorder)
            
                Spacer()
            Divider()
        }.padding()
            .toolbar{
                ToolbarItem {
                    Button(action: {
                        insertUserInstagram(userInstagram: "https://instagram.com/\(userInstagram)")
                        dismiss()

                    }, label: {
                        Image(systemName:"checkmark")
                            .resizable()
                            .foregroundStyle(Color.accentColor)
                            .frame(width:25, height:25)
                    }).toolbarTitleDisplayMode(.inline)
                }
            }
    }
    func insertUserInstagram(userInstagram: String){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{
            return
        }
        
        let userInstagramData = [
            "userInstagram": userInstagram
        ]
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).setData(userInstagramData, merge: true){ err in
                if let err = err {
                    print(err)
                    return
                }
            }
    }
}
struct AddFacebookView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm = UserProfileViewModel()
    
    @State var userFacebook: String = ""
    @State var facebook: String = ""
    var body: some View {
        VStack{
            HStack{
                Text("Add your Facebook")
                    .font(Font.custom("ZingRustDemo-Base", size: 40))
                    .foregroundColor(Color.foreground)
                Spacer()
                }
            
            TextField("Facebook profile link", text: $userFacebook)
                    .font(Font.custom("Jost-Regular", size: 25))
                    .foregroundColor(Color.foreground)
                    .textFieldStyle(.roundedBorder)
            HStack{
                Text("On Facebook, go to profile > three dots > copy profile link")
                    .font(Font.custom("Jost", size: 20))
                    .foregroundColor(Color.foreground)
            }
                Spacer()
            Divider()
        }.padding()
            .toolbar{
                ToolbarItem {
                    Button(action: {
                        insertUserFacebook(userFacebook: "\(userFacebook)")
                        dismiss()

                    }, label: {
                        Image(systemName:"checkmark")
                            .resizable()
                            .foregroundStyle(Color.accentColor)
                            .frame(width:25, height:25)
                    }).toolbarTitleDisplayMode(.inline)
                }
            }
    }
    func insertUserFacebook(userFacebook: String){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{
            return
        }
        
        let userFacebookData = [
            "userFacebook": userFacebook
        ]
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).setData(userFacebookData, merge: true){ err in
                if let err = err {
                    print(err)
                    return
                }
            }
    }
}
struct MyListingsView: View {
    
    @Binding var showSignInView: Bool
    @StateObject private var viewModel = ListingViewModel()
    

    var body: some View {
        VStack{
            HStack{
                Text("My Listings")
                    .font(Font.custom("ZingRustDemo-Base", size: 40))
                    .foregroundColor(Color.foreground)
                Spacer()
            }
            ScrollView{
                HStack{
                    Text("Auction")
                        .font(Font.custom("Jost", size: 30))
                        .foregroundStyle(Color.foreground)
                    Spacer()
                }
                if viewModel.myauctionListings.isEmpty {
                    HStack{
                        Text("No auction listings.")
                            .font(Font.custom("Jost", size: 15))
                            .foregroundColor(Color(red: 0.723, green: 0.717, blue: 0.726))
                        Spacer()
                    }
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack{
                        Spacer()
                        ForEach(viewModel.myauctionListings) { listing in
                            NavigationLink(destination: AuctionListingView(showSignInView: $showSignInView)) {
                                imageBox(imageName: URL(string: listing.imageName![0]), carYear: listing.carYear!, carMake: listing.carMake!, carModel: listing.carModel!, carType: listing.carType!, width: 100, height: 100, textSize: 10, endTime: listing.endTime!, startBid: listing.startBid!)
                            }
                        }
                        Spacer()
                    }
                }
                .task{
                    do{
                        try viewModel.generateMyAuctionListings()
                    }catch {
                        
                    }
                }
                Divider()
                HStack{
                    Text("Renting")
                        .font(Font.custom("Jost", size: 30))
                        .foregroundStyle(Color.foreground)
                    Spacer()
                }
                if viewModel.myrentListings.isEmpty {
                    HStack{
                        Text("No rental listings.")
                            .font(Font.custom("Jost", size: 15))
                            .foregroundColor(Color(red: 0.723, green: 0.717, blue: 0.726))
                        Spacer()
                    }
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack{
                        ForEach(viewModel.myrentListings) { listing in
                            NavigationLink(destination: listingView(showSignInView: $showSignInView, listing: listing)) {
                                imageBox(imageName: URL(string: listing.imageName![0]), carYear: listing.carYear!, carMake: listing.carMake!, carModel: listing.carModel!, carType: listing.carType!, width: 100, height: 100, textSize: 10)
                            }
                        }
                    }
                }
                .task{
                    do{
                        try viewModel.generateMyRentListings()
                    }catch {
                        
                    }
                }
                Divider()
                HStack{
                    Text("Buying")
                        .font(Font.custom("Jost", size: 30))
                        .foregroundStyle(Color.foreground)
                    Spacer()
                }
                if viewModel.mybuyListings.isEmpty {
                    HStack{
                        Text("No vehicles for sale.")
                            .font(Font.custom("Jost", size: 15))
                            .foregroundColor(Color(red: 0.723, green: 0.717, blue: 0.726))
                        Spacer()
                    }
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack{
                        ForEach(viewModel.mybuyListings) { listing in
                            NavigationLink(destination: buyingListingView(showSignInView: $showSignInView, listing: listing)) {
                                imageBox(imageName: URL(string: listing.imageName![0]), carYear: listing.carYear!, carMake: listing.carMake!, carModel: listing.carModel!, carType: listing.carType!, width: 100, height: 100, textSize: 10)
                            }
                        }
                    }
                }
                .task{
                    do{
                        try viewModel.generateMyBuyListings()
                    }catch {
                        
                    }
                }
            }.padding()
        }
    }
}

struct AboutCarQuest: View {
    @Binding var showSignInView: Bool

    var body: some View {
        VStack{
            HStack{
                Text("About Car Quest")
                    .font(Font.custom("ZingRustDemo-Base", size: 40))
                    .foregroundColor(Color.foreground)
                Spacer()
            }
        ScrollView{
                HStack{
                    Image("carQuestLogo")
                        .resizable()
                        .frame(width:150, height:150)
                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    
                    Text("CarQuest is a High School project made by James H. and Maddy Q. in their second year of Mobile Makers.\nCarQuest is a representation of James' and Maddy's SwiftUI, Firebase, and UI design skills.")
                        .font(.custom("Jost-Regular", size: 16))
                        .foregroundStyle(Color.foreground)
                        .multilineTextAlignment(.leading)
                }
                Image("mobileMakersStudio")
                    .resizable()
                    .frame(width:350, height:75)
            }.padding()
        }
    }
}

struct PrivacyView: View {
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack{
            HStack{
                Text("Privacy")
                    .font(Font.custom("ZingRustDemo-Base", size: 40))
                    .foregroundColor(Color.foreground)
                Spacer()
            }
        ScrollView{
                Text("CarQuest ensures its user's privacy by minimizing the collection of user data, promoting 2FA, and using a secure database, Firebase, to store user data.")
                    .font(.custom("Jost-Regular", size: 20))
                    .foregroundStyle(Color.foreground)
                    .multilineTextAlignment(.center)
                Divider()
                Link("Privacy and Security in Firebase", destination: URL(string: "https://firebase.google.com/support/privacy")!)
                    .font(.custom("Jost", size: 20))
                    .foregroundStyle(Color.accent)

            }.padding()
        }
    }
}

struct PurchasesView: View {
    
    @Binding var showSignInView: Bool

    var body: some View {
        VStack{
            HStack{
                Text("Purchases & Payment")
                    .font(Font.custom("ZingRustDemo-Base", size: 40))
                    .foregroundColor(Color.foreground)
                Spacer()
            }
            ScrollView{
                
                }.padding()
            }
        }
    }

struct yearPickerView: View {
    @Environment(\.dismiss) var dismiss

    let years = ["1960", "1961", "1962", "1963", "1964", "1965", "1966", "1967", "1968", "1969", "1970", "1971", "1972", "1973", "1974", "1975", "1976", "1977", "1978", "1979", "1980", "1981", "1982", "1983", "1984", "1985", "1986", "1987", "1988", "1989", "1990", "1991", "1992", "1993", "1994", "1995", "1996", "1997", "1998", "1999", "2000", "2001", "2002", "2003", "2004", "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "2021", "2022", "2023", "2024", "2025"]
    
    @State var yearSearch = ""

    @Binding var carYear: String
    var body: some View {
        VStack{
            TextField("Search for a year...", text: $yearSearch)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width:350, height:35)
                .font(.custom("Jost-Regular", size: 20))
            List{
                ForEach(years.reversed().filter({ yearSearch.isEmpty ? true : $0.localizedCaseInsensitiveContains(yearSearch)}), id: \.self) { years in
                    
                    Button {
                        carYear = years
                        dismiss()
                    } label: {
                        Text(years)
                            .font(.custom("Jost", size: 20))
                    }
                }
            }.listStyle(.plain)
        }.padding()
    }
}
struct makePickerView: View {
    @Environment(\.dismiss) var dismiss

    var makes = ["Acura", "Alfa Romeo", "Aston Martin", "Audi", "Bentley", "BMW", "Bugatti", "Buick", "Cadillac", "Chevrolet", "Chrysler", "Corvette", "Dodge", "Ferrari", "Fiat", "Ford", "Genesis", "GMC", "Honda", "Hyundai", "Infiniti", "Jaguar", "Jeep", "Kia", "Koenigsegg", "Lamborghini", "Lancia", "Land Rover","Lexus", "Lincoln", "Lotus", "Maserati", "Mazda", "McLaren", "Mercedes-Benz", "Mini", "Mitsubishi", "Nissan", "Pagani", "Peugeot", "Porsche", "Ram", "Renault", "Rolls-Royce", "Saab", "Subaru", "Suzuki", "Tesla", "Toyota", "Volkswagen", "Volvo"]
    
    @State var makeSearch = ""

    @Binding var carMake: String
    var body: some View {
        VStack{
            TextField("Search for a make...", text: $makeSearch)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width:350, height:35)
                .font(.custom("Jost-Regular", size: 20))
            List{
                ForEach(makes.filter({ makeSearch.isEmpty ? true : $0.localizedCaseInsensitiveContains(makeSearch)}), id: \.self) { makes in
                    
                    Button {
                        carMake = makes
                        dismiss()
                    } label: {
                        Text(makes)
                            .font(.custom("Jost", size: 20))
                    }
                }
            }.listStyle(.plain)
        }.padding()
    }
}

struct typePickerView: View {
    @Environment(\.dismiss) var dismiss

    var types = ["Sedan", "Coupe", "Hatchback", "Convertible", "Wagon", "Crossover", "SUV", "Pickup", "Minivan", "Van", "EV", "Hybrid", "Off-Road", "Hypercar", "Roadster", "Microcar", "Kei", "Grand Tourer", "Limousine" ]
    
    @State var typeSearch = ""

    @Binding var carType: String
    var body: some View {
        VStack{
            TextField("Search for a type...", text: $typeSearch)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width:350, height:35)
                .font(.custom("Jost-Regular", size: 20))
            List{
                ForEach(types.filter({ typeSearch.isEmpty ? true : $0.localizedCaseInsensitiveContains(typeSearch)}), id: \.self) { types in
                    
                    Button {
                        carType = types
                        dismiss()
                    } label: {
                        Text(types)
                            .font(.custom("Jost", size: 20))
                    }
                }
            }.listStyle(.plain)
        }.padding()
    }
}

struct modelPickerView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var carModel: String

    var body: some View {
        VStack{
            HStack{
                Spacer()
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName:"checkmark")
                        .resizable()
                        .foregroundStyle(Color.accentColor)
                        .frame(width:25, height:25)
                })
            }
            TextField("eg. Civic, Jetta", text: $carModel)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width:350, height:35)
                .font(.custom("Jost-Regular", size: 20))
            Spacer()
        }.padding()
    }
}

