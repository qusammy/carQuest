//
//  listingCreation.swift
//  carQuest
//
//  Created by Maddy Quinn on 8/29/24.
//  Additions by James Hollander
import SwiftUI
import CoreLocation
import PhotosUI
import FirebaseFirestore
import Combine
import FirebaseAnalytics
struct listingCreation: View {
    @ObservedObject var locationManager = LocationManager.shared
    let db = Firestore.firestore()
    
    @State var carType: String
    @State var location: String
    @State var carModel: String
    @State var carMake: String
    @State var carDescription: String
    @State var carYear = "2024"
    let years = ["1990", "1991", "1992", "1993", "1994", "1995", "1996", "1997", "1998", "1999", "2000", "2001", "2002", "2003", "2004", "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "2021", "2022", "2023", "2024"]
    @State var date = Date()
    @State private var photoItem1: PhotosPickerItem?
    @State private var listedPhoto1: Image?
    @State private var photoItem2: PhotosPickerItem?
    @State private var listedPhoto2: Image?
    
    @State var previewListing = false
    
    @Binding var showSignInView: Bool
    var body: some View {
        NavigationView{
            VStack{
                NavigationLink(destination: rentView(showSignInView: $showSignInView).navigationBarBackButtonHidden(true)) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 180, height: 35)
                            .foregroundColor(Color("appColor"))
                        HStack {
                            Image(systemName: "arrow.left")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                            Text("Back to renting")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                    }
                }
                HStack{
                    Text("List a Rental")
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
                        carQuest.previewListing(carYear: $carYear, make: $carMake, model: $carModel, description: $carDescription, typeOfCar: $carType, date: $date, listedPhoto1: $listedPhoto1, listedPhoto2: $listedPhoto2)
                    }
                }
                RoundedRectangle(cornerRadius: 70)
                    .frame(width:345, height:1)
                ScrollView(showsIndicators:false){
                    headline(headerText: "Year")
                    Picker("Select year of vehicle", selection: $carYear){
                        ForEach(years, id: \.self) {
                            Text($0)
                        }
                    }
                    .frame(width:375, height:100)
                    .pickerStyle(.inline)
                    headline(headerText: "Make")
                    listingTextField(carFactor: $carMake, textFieldText: "BMW, Honda, etc.")

                    headline(headerText: "Model")
                    listingTextField(carFactor: $carModel, textFieldText: "Civic, 4Runner, etc.")
                    
                    headline(headerText: "Type")
                    listingTextField(carFactor: $carType, textFieldText: "Sedan, hatchback, etc.")
                    
                    headline(headerText: "Description")
                    listingTextField(carFactor: $carDescription, textFieldText: "Description of vehicle")
                
                    headline(headerText: "Location")
                    Group{
                        if locationManager.userLocation == nil {
                            ZStack{
                                Button(action: {
                                    LocationManager.shared.requestLocation()
                                }, label: {
                                    Text("Request location")
                                        .font(.custom("Jost-Regular", size: 20))
                                        .frame(maxWidth: 375, alignment: .leading)
                                        .multilineTextAlignment(.leading)
                                        .foregroundColor(Color(red: 1.0, green: 0.11372549019607843, blue: 0.11372549019607843))
                                })
                            }
                        } else {
                            Text("Location accessed")
                                .font(.custom("Jost-Regular", size: 20))
                                .frame(maxWidth: 375, alignment: .leading)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(Color(red: 1.0, green: 0.11372549019607843, blue: 0.11372549019607843))
                        }
                    }
                    headline(headerText: "Photos")
                    Text("CarQuest recommends you upload photos with a 1:1 ratio.")
                        .font(.custom("Jost-Regular", size: 15))
                        .foregroundColor(/*@START_MENU_TOKEN@*/Color(red: 0.723, green: 0.717, blue: 0.726)/*@END_MENU_TOKEN@*/)
                        .frame(maxWidth: 375, alignment: .leading)
                        .multilineTextAlignment(.leading)
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
                    Button(action: {
                        createListing()
                    }, label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .frame(maxWidth:150, maxHeight:100)
                                .foregroundColor(Color(red: 1.0, green: 0.11372549019607843, blue: 0.11372549019607843))
                            Text("Post Listing")
                                .font(.custom("Jost-Regular", size: 20))
                                .foregroundColor(.white)
                        }
                    }).frame(maxWidth: 375, alignment: .center)
                }
            }
        }
    }
    func createListing(){
        db.collection("carListings").addDocument(data: [
            "carMake": carMake,
            "carDescription": carDescription,
            "carModel": carModel,
            "carType": carType,
            "carYear": carYear,
        ])
    }
}
#Preview {
    listingCreation(carType: "", location: "", carModel: "", carMake: "", carDescription: "", showSignInView: .constant(false))
}
