import SwiftUI
import CoreLocation
import PhotosUI
import FirebaseFirestore
import Combine
import FirebaseAuth
import FirebaseAnalytics
import FirebaseStorage
import SDWebImage
import MapKit
import SDWebImageSwiftUI
struct BuyingCreation: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var locationManager = LocationManager()
    @StateObject private var viewModel = ProfileViewModel()
    @StateObject var carViewModel = ListingViewModel()
    
    let db = Firestore.firestore()
    @State var listingName: String?
    @State var editListing: Bool
    @State var carType: String
    @State var location: String
    @State var carModel: String
    @State var carMake: String
    @State var carYear: String = "2025"
    let years = ["1960", "1961", "1962", "1963", "1964", "1965", "1966", "1967", "1968", "1969", "1970", "1971", "1972", "1973", "1974", "1975", "1976", "1977", "1978", "1979", "1980", "1981", "1982", "1983", "1984", "1985", "1986", "1987", "1988", "1989", "1990", "1991", "1992", "1993", "1994", "1995", "1996", "1997", "1998", "1999", "2000", "2001", "2002", "2003", "2004", "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020", "2021", "2022", "2023", "2024", "2025"]
    let titles = ["Select a title", "Clean", "Lienholder", "Salvaged", "Bonded", "Junk", "Dismantled", "Reconstructed", "Rebuilt", "Water Damage", "Import"]
    @State var selectedTitle = ""
    @State var listingPrice: String
    @State var carDescription: String
    @State var date = Date()
    @State private var photoItem1 = [PhotosPickerItem]()
    @State private var listedPhotos: UIImage?
    @State private var photo1Data: Data?
    @State private var successText: String = ""
    
    @State var previewListing = false
    @State private var errorText = ""
    @State private var showError: Bool = false
    @State var listingLetter: String?
    
    
    @Binding var showSignInView: Bool
    @State var listingType: String?
    @State var selection: Int?
    @State private var selectedImages = [Data]()
    @State private var previewImages = [UIImage]()
    @State var imageURLs: [URL] = [URL]()
    
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)

    @State var showYearPicker = false
    @State var showMakePicker = false
    @State var showModelPicker = false
    @State var showTypePicker = false
    
    @State var carMileage = ""
    
    @State var listingErrorText = ""

    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    Button(action: {
                        dismiss()
                    }, label: {
                        HStack{
                            backButton()
                        }
                    })
                    Spacer()
                    HStack{
                        Spacer()
                        Text("Sell a Vehicle")
                            .font(Font.custom("Jost-Regular", size:30))
                        Spacer()
                        if carMake.isEmpty || carModel.isEmpty || carType.isEmpty || carYear.isEmpty || carDescription.isEmpty || listingPrice.isEmpty || selectedImages.isEmpty {
                            HStack{
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(maxWidth:80, maxHeight:40)
                                    .foregroundColor(Color.background)
                            }
                        } else {
                            ZStack{
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(maxWidth:80, maxHeight:40)
                                    .foregroundColor(Color(red: 1.0, green: 0.11372549019607843, blue: 0.11372549019607843))
                                Text("Preview")
                                    .font(.custom("Jost-Regular", size: 20))
                                    .foregroundColor(.white)
                            }.onTapGesture {
                                previewListing = true}
                            .sheet(isPresented: $previewListing){
                                carQuest.previewListing(carYear: carYear, make: carMake, model: carModel, carDescription: carDescription, typeOfCar: carType, date: date, listingPrice: listingPrice, listedPhotos: previewImages, isLiked: false)
                            }
                        }
                    }
                }
                ScrollView(showsIndicators:false){
                    HStack{
                        PhotosPicker("Select images", selection: $photoItem1, matching: .images)
                            .font(.custom("Jost-Regular", size:20))
                            .foregroundStyle(Color.accentColor)
                            .onChange(of: photoItem1) {
                       Task {
                           selectedImages.removeAll()
                           previewImages.removeAll()
                            for item in photoItem1 {
                                if let loaded = try? await item.loadTransferable(type: Data.self) {
                                    selectedImages.append(loaded)
                                        } else {
                                            print("Failed")
                                        }
                                    }
                            for item in photoItem1 {
                                if let loaded = try? await item.loadTransferable(type: Image.self) {
                                    let size = CGSize(width: 300, height: 300)
                                    let uiImage = loaded.getUIImage(newSize: size)
                                    previewImages.append(uiImage!)
                                } else {
                                    print("Failed")
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                    if previewImages.isEmpty != true {
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack{
                                Image(uiImage: previewImages[0])
                                    .resizable()
                                    .scaledToFill()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 200, height: 200)
                                    .clipped()
                                if previewImages.count > 1{
                                    Image(uiImage: previewImages[1])
                                        .resizable()
                                        .scaledToFill()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 200, height: 200)
                                        .clipped()
                                    if previewImages.count > 2{
                                        Image(uiImage: previewImages[2])
                                            .resizable()
                                            .scaledToFill()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 200, height: 200)
                                            .clipped()
                                    }
                                }
                            }
                        }
                    } else {
                        HStack{
                            Text("Car Quest recommends to upload photos with a 1:1 ratio.")
                                .font(.custom("Jost-Regular", size: 15))
                                .foregroundColor(Color(red: 0.723, green: 0.717, blue: 0.726))
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    }
                    Text(errorText)
                        .font(Font.custom("Jost-Regular", size:20))
                        .frame(maxWidth: 275)
                        .foregroundStyle(Color.blue)
                                       
                        
                    
                    Divider()
                    
                    //description
                    Group{
                        headline(headerText: "Description")
                        TextField("eg. heated seats, all wheel drive", text: $carDescription, axis: .vertical)
                            .padding(6)
                            .font(.custom("Jost", size: 18))
                            .frame(width:365, height:150, alignment: .topLeading)
                            .overlay {
                                RoundedRectangle(cornerRadius: 3)
                                    .stroke(.gray.opacity(0.2), lineWidth: 2)
                            }
                    }
                    
                    Divider()
                    
                    // year, make, model, type
                    Group{
                        headline(headerText: "Vehicle Information")
                        VStack{
                            HStack{
                                if carYear.isEmpty{
                                    Text("Year")
                                        .font(.custom("Jost-Regular", size: 20))
                                        .foregroundColor(Color.foreground)
                                } else{
                                    Text(carYear)
                                        .font(.custom("Jost-Regular", size: 20))
                                        .foregroundColor(Color.foreground)
                                }
                                Spacer()
                                Image(systemName: "chevron.forward")
                                    .frame(width:35, height:30)
                                    .foregroundColor(.accentColor)
                            }.onTapGesture {
                                showYearPicker.toggle()
                            }.sheet(isPresented: $showYearPicker, content: {
                                yearPickerView(carYear: $carYear)
                            })
                            Divider()
                            HStack{
                                if carMake.isEmpty{
                                    Text("Make")
                                        .font(.custom("Jost-Regular", size: 20))
                                        .foregroundColor(Color.foreground)
                                } else{
                                    Text(carMake)
                                        .font(.custom("Jost-Regular", size: 20))
                                        .foregroundColor(Color.foreground)
                                }
                                Spacer()
                                Image(systemName: "chevron.forward")
                                    .frame(width:35, height:30)
                                    .foregroundColor(.accentColor)
                            }.onTapGesture {
                                showMakePicker.toggle()
                            }.sheet(isPresented: $showMakePicker, content: {
                                makePickerView(carMake: $carMake)
                            })
                            Divider()
                            HStack{
                                if carModel.isEmpty{
                                    Text("Model")
                                        .font(.custom("Jost-Regular", size: 20))
                                        .foregroundColor(Color.foreground)
                                } else{
                                    Text(carModel)
                                        .font(.custom("Jost-Regular", size: 20))
                                        .foregroundColor(Color.foreground)
                                }
                                Spacer()
                                Image(systemName: "chevron.forward")
                                    .frame(width:35, height:30)
                                    .foregroundColor(.accentColor)
                            }.onTapGesture {
                                showModelPicker.toggle()
                            }.sheet(isPresented: $showModelPicker, content: {
                                modelPickerView(carModel: $carModel)
                            })
                            Divider()
                            HStack{
                                if carType.isEmpty{
                                    Text("Type")
                                        .font(.custom("Jost-Regular", size: 20))
                                        .foregroundColor(Color.foreground)
                                } else{
                                    Text(carType)
                                        .font(.custom("Jost-Regular", size: 20))
                                        .foregroundColor(Color.foreground)
                                }
                                Spacer()
                                Image(systemName: "chevron.forward")
                                    .frame(width:35, height:30)
                                    .foregroundColor(.accentColor)
                            }.onTapGesture {
                                showTypePicker.toggle()
                            }.sheet(isPresented: $showTypePicker, content: {
                                typePickerView(carType: $carType)
                            })
                        }.frame(width:350)
                    }
                    
                    Divider()
                    // details
                    headline(headerText: "Vehicle Details")
                    VStack{
                        HStack{
                            Text("Mileage")
                                .font(.custom("Jost", size: 18))
                                .foregroundStyle(Color.foreground)
                            Spacer()
                            TextField("Approx. mileage", text: $carMileage)
                                .font(.custom("Jost", size: 18))
                                .foregroundColor(Color(red: 0.541, green: 0.541, blue: 0.554))
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.numberPad)
                        }
                        HStack{
                            Text("Title")
                                .font(.custom("Jost", size: 18))
                                .foregroundStyle(Color.foreground)
                            Spacer()
                            Picker("Title", selection: $selectedTitle) {
                                ForEach(titles, id: \.self) {
                                    Text($0)
                                }
                            }
                        }
                    }
                    
                    Divider()

                    // price
                    Group{
                        HStack{
                            Text("Price")
                                .font(Font.custom("Jost", size:25))
                                .foregroundStyle(Color.foreground)
                            Spacer()
                            Text("$")
                                .font(.custom("Jost-Regular", size: 20))
                                .italic()
                                .foregroundColor(Color(red: 0.723, green: 0.717, blue: 0.726))
                            TextField("000.00", text: $listingPrice)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width:100, height:35)
                                .font(.custom("Jost-Regular", size: 20))
                                .keyboardType(.numberPad)
                        }
                    }
                    if carMake.isEmpty || carModel.isEmpty || carType.isEmpty || carYear.isEmpty || carDescription.isEmpty || listingPrice.isEmpty || selectedImages.isEmpty || selectedTitle.isEmpty || selectedTitle == "Select a title" {
                        HStack{
                            Spacer()
                            Text("You MUST complete all fields before listing your vehicle.")
                                .multilineTextAlignment(.center)
                                .font(.custom("Jost", size: 18))
                                .foregroundStyle(Color.accentColor)
                            Spacer()
                        }
                    }else {
                        Button {
                            
                            Task{
                                do{
                                    if carViewModel.mybuyListings.count >= 3 {
                                        errorText = "You already have three listings of this type!"
                                    }
                                    else {
                                        try await createBuyingListing(listingExists: false, listingName: "")
                                    }
                                    photo1Data = Data()
                                    showError = false
                                    dismiss()
                                }catch {
                                    showError.toggle()
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
                        }
                    }
                    Text("Users are only allowed to create three listings of each type.")
                        .font(.custom("Jost-Regular", size: 15))
                        .foregroundColor(Color(red: 0.723, green: 0.717, blue: 0.726))
                        .foregroundStyle(Color.accentColor)
                }
            }.padding()
        }
        .onAppear {
            Task{
                do{
                    try carViewModel.generateMyBuyListings()
                }catch {
                    
                }
            }
        }
    }
    func createBuyingListing(listingExists: Bool, listingName: String) async throws {
        var additionalListing: Int = 0
        var additionalPhoto: Int = 0
        var listingID = ""
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        if listingExists == true {
            listingID = listingName
        }else {
            listingID = "\(listingLetter!)\(additionalListing)\(userID)"
            
            
            if listingType == "Rental" {
                listingLetter = "R"
            }else if listingType == "Auction" {
                listingLetter = "A"
            }else if listingType == "For Sale" {
                listingLetter = "B"
            }
            
            let document = try await Firestore.firestore().collection("carListings").document(listingID).getDocument()
            
            if document.exists {
                additionalListing += 1
            }
            
            let document1 = try await Firestore.firestore().collection("carListings").document(listingID).getDocument()
            
            if document1.exists {
                additionalListing += 1
            }
            
            let document2 = try await Firestore.firestore().collection("carListings").document(listingID).getDocument()
            
            if document2.exists {
                errorText = "Users are only allowed to create three listings of each type"
            }
        }
        
        date = Date.now
        
        try await db.collection("carListings").document(listingID).setData([
            "carMake": carMake,
            "carModel": carModel,
            "carType": carType,
            "carYear": carYear,
            "userID": userID,
            "listingType" : "buying",
            "imageName" : "https://firebasestorage.googleapis.com/v0/b/carquest-4038a.appspot.com/o/4.png?alt=media&token=d79fb423-974c-4b7c-87ac-0dd495ab66e5",
            "listingPrice": listingPrice,
            "carDescription": carDescription,
            "carMileage": carMileage,
            "carTitle": selectedTitle,
            "listingID" : listingID,
            "dateCreated" : date,
            "usersLiked" : [],
            "listingTitle": "\(carYear) \(carMake) \(carModel) \(carType)",
            "location": location
        ], merge: true)
        if selectedImages.isEmpty == false {
            try await db.collection("carListings").document(listingID).setData([
                "imageName" : "https://firebasestorage.googleapis.com/v0/b/carquest-4038a.appspot.com/o/4.png?alt=media&token=d79fb423-974c-4b7c-87ac-0dd495ab66e5"
            ], merge: true)
            for image in selectedImages {
                let uiImage = UIImage(data: image)
                listedPhotos = uiImage
                
                guard listedPhotos != nil else{
                    print("No image")
                    return
                }
                
                let storageRef = Storage.storage().reference()
                let imageData = listedPhotos!.jpegData(compressionQuality: 0.8)
                
                guard imageData != nil else {
                    print("Problem turning photo into data")
                    return
                }
                
                let path = "listingImages/\(additionalPhoto)\(listingID).jpeg"
                let fileRef = storageRef.child(path)
                
                fileRef.putData(imageData!, metadata: nil) { (metadata, error) in
                    if error == nil && metadata != nil {
                        let ref = Storage.storage().reference(withPath: path)
                        ref.downloadURL { url, err in
                            if err == nil{
                                
                            }
                            guard let url = url else { return }
                            AuthenticationManager.shared.updateImage(imageURLs: url,additionalListing: additionalListing, listingLetter: listingLetter!)
                        }
                    }
                    
                }
                additionalPhoto += 1
            }

            selectedImages.removeAll()
        }
    }
    
}
#Preview {
    BuyingCreation(editListing: false, carType: "", location: "", carModel: "", carMake: "", carYear: "", listingPrice: "", carDescription: "", showSignInView: .constant(false))
}
