import SwiftUI

struct AuctionView: View {
    @Binding var showSignInView: Bool
    @State var userPreferences = ""
    @State private var creationIsPresented: Bool = false
    @StateObject private var vm = ListingViewModel()
    @State private var isPresented = false
    
    @State private var shuffledList: [carListing] = [carListing]()
    
    // selections for filter pickers
    let years = ["Select a year", "1960", "1961", "1962", "1963", "1964", "1965", "1966", "1967", "1968", "1969", "1970", "1971", "1972", "1973", "1974", "1975", "1976", "1977", "1978", "1979", "1980", "1981", "1982", "1983", "1984", "1985", "1986", "1987", "1988", "1989", "1990", "1991", "1992", "1993", "1994", "1995", "1996", "1997", "1998", "1999", "2000", "2001", "2002", "2003", "2004", "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "2021", "2022", "2023", "2024", "2025"]
    let makes = ["Select a make", "Acura", "Alfa Romeo", "Aston Martin", "Audi", "Bentley", "BMW", "Bugatti", "Buick", "Cadillac", "Chevrolet", "Chrysler", "Corvette", "Dodge", "Ferrari", "Fiat", "Ford", "Genesis", "GMC", "Honda", "Hyundai", "Infiniti", "Jaguar", "Jeep", "Kia", "Koenigsegg", "Lamborghini", "Lancia", "Land Rover","Lexus", "Lincoln", "Lotus", "Maserati", "Mazda", "McLaren", "Mercedes-Benz", "Mini", "Mitsubishi", "Nissan", "Pagani", "Peugeot", "Porsche", "Ram", "Renault", "Rolls-Royce", "Saab", "Subaru", "Suzuki", "Tesla", "Toyota", "Volkswagen", "Volvo"]
    let types = ["Select a type", "Sedan", "Coupe", "Hatchback", "Convertible", "Sport", "Wagon", "Crossover", "SUV", "Pickup", "Minivan", "Van", "Luxury", "EV", "Hybrid", "Off-Road", "Hypercar", "Roadster", "Microcar", "Kei", "Grand Tourer", "Limousine" ]
    
    // filter that is written or chosen by user
    @State var searchText: String
    @State var selectedYear = ""
    @State var selectedMake = ""
    @State var selectedModel = ""
    @State var selectedType = ""

    //filtering the shuffledList
    var filteredList: [carListing] {
        var filtered = shuffledList
        
        if !searchText.isEmpty {
            filtered = filtered.filter{
                $0.listingTitle!.localizedCaseInsensitiveContains(searchText)
            }
        }
        if !selectedYear.isEmpty {
            filtered = filtered.filter{
                $0.carYear == selectedYear
            }
        }
        if !selectedMake.isEmpty {
            filtered = filtered.filter{
                $0.carMake == selectedMake
            }
        }
        if !selectedModel.isEmpty {
            filtered = filtered.filter{
                $0.carModel!.localizedCaseInsensitiveContains(selectedModel)
            }
        }
        if !selectedType.isEmpty {
            filtered = filtered.filter{
                $0.carType == selectedType
            }
        }
        return filtered
    }
    

    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    Text("Auction services")
                        .foregroundColor(Color.foreground)
                        .font(.custom("ZingRustDemo-Base", size: 32))
                    Spacer()
                    Button{
                        creationIsPresented.toggle()
                    }label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width:135, height:35)
                                .foregroundColor(Color("appColor"))
                            Text("Auction a car")
                                .foregroundColor(.white)
                                .font(.custom("Jost-Regular", size: 20))
                        }
                    } .fullScreenCover(isPresented: $creationIsPresented) {
                        listingCreation(carType: "", location: "", carModel: "", carMake: "", listingPrice: "", carDescription: "", listingLetter: "A", showSignInView: $showSignInView, selection: 1)
                    }
                }
                HStack{
                    Button {
                        isPresented.toggle()
                    } label: {
                        Image(systemName: "list.bullet.circle.fill")
                            .resizable()
                            .foregroundColor(Color.accentColor)
                            .frame(width:30, height:30)
                    }
                    Spacer()
                    HStack{
                        Image(systemName: "magnifyingglass.circle.fill")
                            .resizable()
                            .frame(width:30, height:30)
                            .foregroundColor(Color.accentColor)
                        ZStack{
                            RoundedRectangle(cornerRadius: 10.0)
                                .frame(width:205, height:35)
                                .foregroundStyle(Color(hue: 0.975, saturation: 0.0, brightness: 0.953))
                            TextField("Search for a dream car...", text: $searchText)
                                .frame(width:200, height:30)
                                .font(.custom("Jost-Regular", size: 18))
                            }
                        if searchText != "" {
                                Button(action: {
                                    searchText = ""
                                }, label: {
                                    Image(systemName: "trash.circle.fill")
                                        .resizable()
                                        .frame(width: 30, height:30)
                                    })
                                }
                            }
                        }
                ScrollView(showsIndicators: false){
                    if filteredList.isEmpty {
                        Text("Please reset your filters.")
                            .font(.custom("Jost", size: 18))
                            .foregroundStyle(Color(red: 0.723, green: 0.717, blue: 0.726))
                    } else {
                        ForEach(filteredList){
                            listing in
                            NavigationLink(destination: listingView(showSignInView: $showSignInView, listing: listing)) {
                                imageBox(imageName:URL(string: listing.imageName![0]), carYear: listing.carYear!, carMake: listing.carMake!, carModel: listing.carModel!, carType: listing.carType!, width: 250, height: 250, textSize: 22)
                            }
                        }
                    }
                }
            }
            .padding()
            .fullScreenCover(isPresented: $isPresented, content: {
                VStack{
                    HStack{
                        Button(action: {
                            selectedModel = ""
                            selectedType = ""
                            selectedMake = ""
                            selectedYear = ""
                        }, label: {
                            Text("Reset")
                                .foregroundColor(Color.accentColor)
                                .font(Font.custom("Jost-Regular", size:18))
                                .underline()
                        })
                        Spacer()
                        Text("Filters")
                            .font(.custom("ZingRustDemo-Base", size: 30))
                            .foregroundStyle(Color.foreground)
                        Spacer()
                        Button(action: {
                            isPresented.toggle()
                            
                        }, label: {
                            Image(systemName:"checkmark")
                                .resizable()
                                .foregroundStyle(Color.accentColor)
                                .frame(width:25, height:25)
                        })
                    }
                    List{
                        Section {
                            Picker("Year", selection: $selectedYear) {
                                ForEach(years, id: \.self) {
                                   Text($0)
                                }
                            }.font(.custom("Jost", size: 18))
                        }
                        Section {
                            Picker("Make", selection: $selectedMake) {
                                ForEach(makes, id: \.self) {
                                    Text($0)
                                        
                                }
                            }.font(.custom("Jost", size: 18))
                        }
                        Section {
                            HStack{
                                Text("Model")
                                    .font(.custom("Jost", size: 18))
                                    .foregroundStyle(Color.foreground)
                                Spacer()
                                TextField("Search for a model", text: $selectedModel)
                                    .font(.custom("Jost", size: 18))
                                    .foregroundColor(Color(red: 0.541, green: 0.541, blue: 0.554))
                                    .multilineTextAlignment(.trailing)
                            }
                        }
                        Section {
                            Picker("Type", selection: $selectedType) {
                                ForEach(types, id: \.self) {
                                    Text($0)
                                }
                            }.font(.custom("Jost", size: 18))
                        }
                    }.listStyle(.plain)
                }.padding()
            })
            .padding()
            .task {
                vm.generateAuctionListings()
            }
        }
    }
}

#Preview {
    AuctionView(showSignInView: .constant(false), searchText: "")
}
