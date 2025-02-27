import Foundation
import SwiftUI

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
            ScrollView(showsIndicators: false){
                HStack{
                    Text("Push Notifications")
                        .font(Font.custom("ZingRustDemo-Base", size: 40))
                        .foregroundColor(Color.foreground)
                    Spacer()
                    }
                    Toggle(isOn: $pushNotification) {
                        Text("Enable push notifications")
                            .font(Font.custom("Jost-Regular", size: 20))
                            .foregroundColor(Color.foreground)
                    }.toggleStyle(SwitchToggleStyle(tint: .accentColor))
                    Spacer()
                Divider()
            }.padding()
        }
    }
}

struct MyListingsView: View {
    
    @Binding var showSignInView: Bool
    @StateObject private var viewModel = ListingViewModel()
    

    var body: some View {
        ScrollView{
            VStack{
                HStack{
                    Text("My Listings")
                        .font(Font.custom("ZingRustDemo-Base", size: 40))
                        .foregroundColor(Color.foreground)
                    Spacer()
                }
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
                            NavigationLink(destination: listingView(showSignInView: $showSignInView, listing: listing)) {
                                imageBox(imageName: URL(string: listing.imageName![0]), carYear: listing.carYear!, carMake: listing.carMake!, carModel: listing.carModel!, carType: listing.carType!, width: 100, height: 100, textSize: 10)
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
                            NavigationLink(destination: listingView(showSignInView: $showSignInView, listing: listing)) {
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
        ScrollView{
            VStack{
                HStack{
                    Text("About Car Quest")
                        .font(Font.custom("ZingRustDemo-Base", size: 40))
                        .foregroundColor(Color.foreground)
                    Spacer()
                }
               Text("Hi")
            }.padding()
        }
    }
}

struct PrivacyView: View {
    @Binding var showSignInView: Bool
    
    var body: some View {
        ScrollView{
            VStack{
                HStack{
                    Text("Privacy")
                        .font(Font.custom("ZingRustDemo-Base", size: 40))
                        .foregroundColor(Color.foreground)
                    Spacer()
                }
            }.padding()
        }
    }
}

struct PurchasesView: View {
    
    @Binding var showSignInView: Bool

    var body: some View {
            ScrollView{
                VStack{
                    HStack{
                        Text("Purchases & Payment")
                            .font(Font.custom("ZingRustDemo-Base", size: 40))
                            .foregroundColor(Color.foreground)
                        Spacer()
                    }
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

    var types = ["Sedan", "Coupe", "Hatchback", "Convertible", "Sport", "Wagon", "Crossover", "SUV", "Pickup", "Minivan", "Van", "Luxury", "EV", "Hybrid", "Off-Road", "Hypercar", "Roadster", "Microcar", "Kei", "Grand Tourer", "Limousine" ]
    
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

