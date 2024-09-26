//
//  listingCreation.swift
//  carQuest
//
//  Created by Maddy Quinn on 8/29/24.
//  Additions by James Hollander

import SwiftUI
import CoreLocation
import PhotosUI

struct listingCreation: View {
    @State var typeOfCar: String
    @State var location: String
    @State var model: String
    @State var make: String
    @State var description: String
    @State var carYear = "2024"
    let years = ["1990", "1991", "1992", "1993", "1994", "1995", "1996", "1997", "1998", "1999", "2000", "2001", "2002", "2003", "2004", "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "2021", "2022", "2023", "2024"]
    @State var previewListing = false
    @State var date = Date()
    @State private var photoItem1: PhotosPickerItem?
    @State private var listedPhoto1: Image?
    @State private var photoItem2: PhotosPickerItem?
    @State private var listedPhoto2: Image?
    var suggestions: Array = ["Audi", "BMW", "Fiat", "Ford"]
    var body: some View {
        VStack{
            Button(action: {
                //exits out of listing page, back to home page
            }, label: {
                ZStack{
                    Image(systemName: "x.circle.fill")
                        .resizable()
                        .frame(width:40, height:40)
                        .foregroundColor(.black)
                }
            }).frame(maxWidth: 375, alignment: .leading)
            
            HStack{
                Text("Create listing")
                    .font(Font.custom("Jost-Regular", size:40))
                    .frame(maxWidth: 275, alignment: .leading)
                
                ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .frame(maxWidth:100, maxHeight:50)
                            .foregroundColor(Color(red: 1.0, green: 0.11372549019607843, blue: 0.11372549019607843))
                        Text("Preview")
                            .font(.custom("Jost-Regular", size: 25))
                            .foregroundColor(.white)
                    }.onTapGesture {
                        previewListing = true}
                    .sheet(isPresented: $previewListing){
                        carQuest.previewListing(carYear: $carYear, make: $make, model: $model, description: $description, typeOfCar: $typeOfCar, date: $date, listedPhoto1: $listedPhoto1, listedPhoto2: $listedPhoto2)
                        }
            }
            ScrollView(showsIndicators:false){
                headline(headerText: "Type")
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        carType(type: "SUV")
                            .onTapGesture {
                                typeOfCar = "SUV"
                            }
                        carType(type: "Sedan")
                        carType(type: "Coupe")
                        carType(type: "Truck")
                        carType(type: "Minivan")
                        carType(type: "Hatchback")
                        carType(type: "Van")
                        carType(type: "Convertible")
                        
                    }
                }.frame(maxWidth: 375, alignment: .leading)
                headline(headerText: "Make")
                TextField("BMW, Honda, etc.", text: $make)
                    .foregroundColor(.black)
                    .frame(width:375, height:50)
                    .font(.custom("Jost-Regular", size: 20))
                    .background(Color(hue: 1.0, saturation: 0.005, brightness: 0.927))
                    .cornerRadius(10)
                    .multilineTextAlignment(.leading)
                
                headline(headerText: "Model")
                TextField("Civic, 4Runner, etc.", text: $model)
                    .foregroundColor(.black)
                    .frame(width:375, height:50)
                    .font(.custom("Jost-Regular", size: 20))
                    .background(Color(hue: 1.0, saturation: 0.005, brightness: 0.927))
                    .cornerRadius(10)
                    .multilineTextAlignment(.leading)
                    .disableAutocorrection(true)
                headline(headerText: "Year")
                Picker("Select year of vehicle", selection: $carYear){
                    ForEach(years, id: \.self) {
                        Text($0)
                        
                    }
                }
                .frame(width:375, height:100)
                .pickerStyle(.inline)
                
                headline(headerText: "Description")
                TextField("Description of vehicle", text: $description)
                    .foregroundColor(.black)
                    .frame(width:375, height:50)
                    .font(.custom("Jost-Regular", size: 20))
                    .background(Color(hue: 1.0, saturation: 0.005, brightness: 0.927))
                    .cornerRadius(10)
                    .multilineTextAlignment(.leading)
                headline(headerText: "Location")
                TextField("City, zip, address", text: $location)
                    .foregroundColor(.black)
                    .frame(width:375, height:50)
                    .font(.custom("Jost-Regular", size: 20))
                    .background(Color(hue: 1.0, saturation: 0.005, brightness: 0.927))
                    .cornerRadius(10)
                    .multilineTextAlignment(.leading)
                    .disableAutocorrection(true)
                headline(headerText: "Photos")
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width:200, height:200)
                                .foregroundColor(Color(hue: 1.0, saturation: 0.005, brightness: 0.927))
                            PhotosPicker("Select image", selection: $photoItem1, matching: .images)
                                .font(.custom("Jost-Regular", size:20))
                                .foregroundColor(/*@START_MENU_TOKEN@*/Color(red: 0.723, green: 0.717, blue: 0.726)/*@END_MENU_TOKEN@*/)
                            
                            listedPhoto1?
                                .resizable()
                                .scaledToFill()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 200, height: 200)
                                .clipped()
                        }
                        .onChange(of: photoItem1) {
                            Task {
                                if let loaded = try? await photoItem1?.loadTransferable(type: Image.self) {
                                    listedPhoto1 = loaded
                                } else {
                                    print("Failed")
                                }
                            }
                        }
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width:200, height:200)
                                .foregroundColor(Color(hue: 1.0, saturation: 0.005, brightness: 0.927))
                            PhotosPicker("Select image", selection: $photoItem2, matching: .images)
                                .font(.custom("Jost-Regular", size:20))
                                .foregroundColor(/*@START_MENU_TOKEN@*/Color(red: 0.723, green: 0.717, blue: 0.726)/*@END_MENU_TOKEN@*/)
                            
                            listedPhoto2?
                                .resizable()
                                .scaledToFill()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 200, height: 200)
                                .clipped()
                        }
                        .onChange(of: photoItem2) {
                            Task {
                                if let loaded = try? await photoItem2?.loadTransferable(type: Image.self) {
                                    listedPhoto2 = loaded
                                } else {
                                    print("Failed")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
#Preview {
    listingCreation(typeOfCar: "", location: "", model: "", make: "", description: "")
}

struct headline: View {
    var headerText: String
    var body: some View {
        Text(headerText)
            .font(Font.custom("ZingRustDemo-Base", size:30))
            .frame(maxWidth: 375, alignment: .leading)
    }
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
                                        .font(.custom("Jost-Regular", size:17))
                                        .foregroundColor(.black)
                                  }
                              }
                   })
        }
    }
}

struct previewListing: View {
    @Binding var carYear: String
    @Binding var make: String
    @Binding var model: String
    @Binding var description: String
    @Binding var typeOfCar: String
    @Binding var date: Date
    @Binding var listedPhoto1: Image?
    @Binding var listedPhoto2: Image?
    var body: some View{
        VStack{
            RoundedRectangle(cornerRadius: 70)
                .frame(width:345, height:2)
                .padding(.top, 5.0)
            Text("Preview listing")
                .font(.custom("Jost-Regular", size: 30))
                .foregroundColor(.black)
            ScrollView{
                ScrollView(.horizontal, showsIndicators: false)
                {
                    HStack{
                        listedPhoto1?
                            .resizable()
                            .clipped()
                            .frame(width:300, height:300)
                        listedPhoto2?
                            .resizable()
                            .clipped()
                            .frame(width:300, height:300)
                    }
                }
                
                Text("\(carYear) \(make) \(model) \(typeOfCar)")
                    .font(.custom("Jost-Regular", size: 25))
                    .foregroundColor(.black)
                HStack{
                    Image("profileIcon")
                        .resizable()
                        .frame(width:55, height:55)
                    Text("$username")
                        .font(.custom("Jost-Regular", size: 20))
                        .foregroundColor(.black)
                        .frame(maxWidth: 375, alignment: .leading)
                }
                Text("\(description)")
                    .font(.custom("Jost-Regular", size: 20))
                    .foregroundColor(.black)
                    .frame(maxWidth: 375, alignment: .leading)
                    .multilineTextAlignment(.leading)
                Text("Listed \(date)")
                    .font(.custom("Jost-Regular", size: 20))
                    .foregroundColor(.gray)
                    .frame(maxWidth: 375, alignment: .leading)
            }
        }
    }
}
