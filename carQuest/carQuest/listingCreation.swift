//
//  listingCreation.swift
//  carQuest
//
//  Created by Maddy Quinn on 8/29/24.
//
import SwiftUI
import CoreLocation
struct listingCreation: View {
    @State var typeOfCar: String
    @State var location: String
    @State var model: String
    @State var make: String
    @State var description: String
    @State private var carYear = "2024"
    let years = ["1990", "1991", "1992", "1993", "1994", "1995", "1996", "1997", "1998", "1999", "2000", "2001", "2002", "2003", "2004", "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "2021", "2022", "2023", "2024"]
    var suggestions: Array = ["Audi", "BMW", "Fiat", "Ford"]
    
    //  @StateObject private var locationManager = LocationManager()
    var body: some View {
        VStack{
            Button(action: {
                //exits out of listing page, back to home page
            }, label: {
                ZStack{
                    Image(systemName: "x.circle.fill")
                        .resizable()
                        .frame(width:40, height:40)
                        .foregroundColor(Color(red: 1.0, green: 0.11372549019607843, blue: 0.11372549019607843))
                }
            }).frame(maxWidth: 375, alignment: .leading)
            
            
            Text("Create listing")
                .font(Font.custom("Jost-Regular", size:40))
                .frame(maxWidth: 375, alignment: .leading)
            ScrollView{
                Text("Type of car")
                    .font(Font.custom("ZingRustDemo-Base", size:30))
                    .frame(maxWidth: 375, alignment: .leading)
                ScrollView(.horizontal){
                    HStack{
                        carType(type: "SUV")
                        carType(type: "Sedan")
                        carType(type: "Coupe")
                        carType(type: "Sport")
                        carType(type: "Truck")
                        carType(type: "Minivan")
                        carType(type: "Hatchback")
                        carType(type: "Van")
                        carType(type: "Convertible")
                        
                    }
                }.frame(maxWidth: 375, alignment: .leading)
                Text("Make")
                    .font(Font.custom("ZingRustDemo-Base", size:30))
                    .frame(maxWidth: 375, alignment: .leading)
                TextField("BMW, Honda, etc.", text: $make)
                    .foregroundColor(.black)
                    .frame(width:375, height:50)
                    .font(.custom("Jost-Regular", size: 20))
                    .background(Color(hue: 1.0, saturation: 0.005, brightness: 0.927))
                    .cornerRadius(10)
                    .multilineTextAlignment(.leading)
                
                Text("Model")
                    .font(Font.custom("ZingRustDemo-Base", size:30))
                    .frame(maxWidth: 375, alignment: .leading)
                TextField("Civic, 4Runner, etc.", text: $model)
                    .foregroundColor(.black)
                    .frame(width:375, height:50)
                    .font(.custom("Jost-Regular", size: 20))
                    .background(Color(hue: 1.0, saturation: 0.005, brightness: 0.927))
                    .cornerRadius(10)
                    .multilineTextAlignment(.leading)
                    .disableAutocorrection(true)
                Text("Year")
                    .font(Font.custom("ZingRustDemo-Base", size:30))
                    .frame(maxWidth: 375, alignment: .leading)
                Picker("Select year of vehicle", selection: $carYear){
                                ForEach(years, id: \.self) {
                                    Text($0)
                                        
                                }
                }.pickerStyle(.inline)
    
                Text("Description")
                    .font(Font.custom("ZingRustDemo-Base", size:30))
                    .frame(maxWidth: 375, alignment: .leading)
                TextField("Description of vehicle", text: $description)
                    .foregroundColor(.black)
                    .frame(width:375, height:50)
                    .font(.custom("Jost-Regular", size: 20))
                    .background(Color(hue: 1.0, saturation: 0.005, brightness: 0.927))
                    .cornerRadius(10)
                    .multilineTextAlignment(.leading)
                Text("Location")
                    .font(Font.custom("ZingRustDemo-Base", size:30))
                    .frame(maxWidth: 375, alignment: .leading)
                TextField("City, zip, address", text: $location)
                    .foregroundColor(.black)
                    .frame(width:375, height:50)
                    .font(.custom("Jost-Regular", size: 20))
                    .background(Color(hue: 1.0, saturation: 0.005, brightness: 0.927))
                    .cornerRadius(10)
                    .multilineTextAlignment(.leading)
                    .disableAutocorrection(true)
                Text("Photos")
                    .font(Font.custom("ZingRustDemo-Base", size:30))
                    .frame(maxWidth: 375, alignment: .leading)
                
                //asks for location perms
                //                .onTapGesture {
                //                    locationManager.checkLocationAuthorization()
                //                }
                
                // gives coordinates
                //            if let coordinate = locationManager.lastKnownLocation {
                //                Text("\(reverseGeocoding(latitude:37.334730, longitude: -122.008919))")
                //                Text("Latitude: \(coordinate.latitude)")
                //                    .font(Font.custom("ZingRustDemo-Base", size:20))
                //                    .frame(maxWidth: 375, alignment: .leading)
                //                Text("Longitude: \(coordinate.longitude)")
                //                    .font(Font.custom("ZingRustDemo-Base", size:20))
                //                    .frame(maxWidth: 375, alignment: .leading)
                //                       } else {
                //                           Text("Unknown Location")
                //                               .font(Font.custom("ZingRustDemo-Base", size:20))
                //                               .frame(maxWidth: 375, alignment: .leading)
                //                       }
                
            }
        }
    }
}
#Preview {
    listingCreation(typeOfCar: "", location: "", model: "", make: "", description: "")
}
struct carType: View {
    var type: String
    @State var isTypeOfCarSelected: Bool = false
    
    var body: some View {
        
            VStack{
                Button(action: { isTypeOfCarSelected.toggle() },
                          label: {
                              switch isTypeOfCarSelected {
                                  case true:
                                  ZStack{
                                      RoundedRectangle(cornerRadius: 10)
                                          .frame(width:100, height:60)
                                          .foregroundColor(Color(red: 1.0, green: 0.11372549019607843, blue: 0.11372549019607843))
                                      Text("\(type)")
                                          .font(.custom("Jost-Regular", size: 17))
                                          .foregroundColor(.white)
                                      
                                  }
                                  default:
                                  ZStack{
                                      RoundedRectangle(cornerRadius: 10)
                                          .frame(width:100, height:60)
                                          .foregroundColor(Color(hue: 1.0, saturation: 0.005, brightness: 0.92))
                                      Text("\(type)")
                                          .font(.custom("Jost-Regular", size: 17))
                                          .foregroundColor(.black)
                                  }
                              }
                   })
        }
    }
}
 
struct carBrand: View {
    var brand: String
    @State var isCarBrandSelected: Bool = false
    var body: some View {
            VStack{
                Button(action: { isCarBrandSelected.toggle() },
                          label: {
                              switch isCarBrandSelected {
                                  case true:
                                  ZStack{
                                      RoundedRectangle(cornerRadius: 10)
                                          .frame(width:100, height:60)
                                          .foregroundColor(Color(red: 1.0, green: 0.11372549019607843, blue: 0.11372549019607843))
                                      Text("\(brand)")
                                          .font(.custom("Jost-Regular", size: 17))
                                          .foregroundColor(.white)
                                  }
                                  default:
                                  ZStack{
                                      RoundedRectangle(cornerRadius: 10)
                                          .frame(width:100, height:60)
                                          .foregroundColor(Color(hue: 1.0, saturation: 0.005, brightness: 0.92))
                                      Text("\(brand)")
                                          .font(.custom("Jost-Regular", size: 17))
                                          .foregroundColor(.black)
                                  }
                              }
                   })
        }
    }
}

