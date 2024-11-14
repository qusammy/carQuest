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
import FirebaseAuth
import FirebaseAnalytics
import FirebaseStorage
struct listingCreation: View {
    @ObservedObject var locationManager = LocationManager.shared
    @StateObject private var viewModel = ProfileViewModel()
    @StateObject private var carViewModel = ListingViewModel()

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
    @State private var listedPhoto1: UIImage?
    @State private var photo1Data: Data?
    @State private var successText: String = ""
    
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
                        carQuest.previewListing(carYear: $carYear, make: $carMake, model: $carModel, description: $carDescription, typeOfCar: $carType, date: $date, listedPhoto1: $listedPhoto1)
                    }
                }
                Text("Users are only allowed to create three listings of each type!")
                    .font(Font.custom("Jost-Regular", size:20))
                    .frame(maxWidth: 275)
                    .foregroundStyle(Color.blue)
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
                    headline(headerText: "Photo")
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
                                if let photo1Data,
                                   let uiImage = UIImage(data: photo1Data) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 200, height: 200)
                                        .clipped()
                                }
                            }
                            .onChange(of: photoItem1) {
                                Task {
                                    if let loaded = try? await photoItem1?.loadTransferable(type: Data.self) {
                                        photo1Data = loaded
                                    } else {
                                        print("Failed")
                                    }
                                }
                            }
                        }
                    }
                    Button {
                        Task{
                            do{
                                try await createListingRenting()
                            }catch {
                                print(error)
                            }
                        }
                        
                    } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .frame(maxWidth:150, maxHeight:100)
                                    .foregroundColor(Color(red: 1.0, green: 0.11372549019607843, blue: 0.11372549019607843))
                                Text("Post Listing")
                                    .font(.custom("Jost-Regular", size: 20))
                                    .foregroundColor(.white)
                            }
                    }.frame(maxWidth: 375, alignment: .center)
                    Text(successText)
                        .font(Font.custom("Jost-Regular", size:20))
                        .frame(maxWidth: 275)
                        .foregroundStyle(Color.accentColor)
                }
            }
        }
    }
    func createListingRenting() async throws {
        var additionalListing: Int = 0
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        let document = try await Firestore.firestore().collection("carListings").document("\(additionalListing)\(userID)").getDocument()
        
        if document.exists {
            additionalListing += 1
        }
        
        let document1 = try await Firestore.firestore().collection("carListings").document("\(additionalListing)\(userID)").getDocument()
        
        if document1.exists {
            additionalListing += 1
        }
        
        let document2 = try await Firestore.firestore().collection("carListings").document("\(additionalListing)\(userID)").getDocument()
        
        if document2.exists {
            print("Users are only allowed to create three listings of each type.")
        }

        try await db.collection("carListings").document("\(additionalListing)\(userID)").setData([
                "carMake": carMake,
                "carDescription": carDescription,
                "carModel": carModel,
                "carType": carType,
                "carYear": carYear,
                "userID": userID,
                "listingType" : "renting",
                "imageName" : "carQuestLogo"
        ])
        
        if let photo1Data,
           let uiImage = UIImage(data: photo1Data) {
            listedPhoto1 = uiImage
        }

        guard listedPhoto1 != nil else{
            print("No image")
            return
        }
        
        let storageRef = Storage.storage().reference()
        let imageData = listedPhoto1!.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else {
            print("Problem turning photo into data")
            return
        }
        let path = "listingImages/\(UUID().uuidString).jpeg"
        let fileRef = storageRef.child(path)
        
        let uploadTask = fileRef.putData(imageData!, metadata: nil) { (metadata, error) in
            if error == nil && metadata != nil {
                let db = Firestore.firestore()
                db.collection("carListings").document("\(additionalListing)\(userID)").setData(["imageName": path], merge: true)
            }
        }
    }
}
#Preview {
    listingCreation(carType: "", location: "", carModel: "", carMake: "", carDescription: "", showSignInView: .constant(false))
}
