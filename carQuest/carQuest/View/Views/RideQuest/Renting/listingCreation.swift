import SwiftUI
import CoreLocation
import PhotosUI
import FirebaseFirestore
import Combine
import FirebaseAuth
import FirebaseAnalytics
import FirebaseStorage
import MapKit

struct listingCreation: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel = ProfileViewModel()
    @StateObject var carViewModel = ListingViewModel()
    
    let db = Firestore.firestore()
    
    @State var carType: String
    @State var location: String
    @State var carModel: String
    @State var carMake: String
    @State var carYear: String

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
    @State private var carPhoto: UIImage?
    @State var listingLetter: String?
    
    
    @Binding var showSignInView: Bool
    @State var listingType: String?
    @State var selection: Int?
    @State private var selectedImages = [Data]()
    @State private var previewImages = [UIImage]()
    @State private var imageURLs: [URL] = [URL]()
    
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
    @State var showYearPicker = false
    @State var showMakePicker = false
    @State var showModelPicker = false
    @State var showTypePicker = false
    
//    struct IdentifiableInfo: Identifiable {
//        var id = UUID()
//        var name: String
//        var navigationLink: AnyView
//    }
//    
//    @State var info: [IdentifiableInfo] = [
//        IdentifiableInfo(name: "Year", navigationLink: AnyView.init(yearPickerView()))]
//    
    @State var yearPicker = false
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
                    Text("List a Vehicle")
                        .font(Font.custom("ZingRustDemo-Base", size:32))
                    Spacer()
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
                ScrollView(showsIndicators:false){
                    //photos
                    Group {
                    headline(headerText: "Photos")
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
                }
                
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
                            Text("*per day")
                                .font(.custom("Jost-Regular", size: 20))
                                .italic()
                                .foregroundColor(Color(red: 0.723, green: 0.717, blue: 0.726))
                        }
                    }
                    
                    
                    
                    HStack{
                        headline(headerText: "Location")
                        Spacer()
                    }
                    HStack{
                        Map(position: $position){
                            
                        }
                        .frame(width:300, height:300)
                        .clipShape(RoundedRectangle(cornerRadius: 15.0))
                        Spacer()
                    }
                    
                    Button {
                        Task{
                            do{
                                try await createListingRenting()
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
                    Text("Users are only allowed to create three listings of each type!")
                        .font(.custom("Jost-Regular", size: 15))
                        .foregroundColor(Color(red: 0.723, green: 0.717, blue: 0.726))
                        .multilineTextAlignment(.leading)
                    Text(successText)
                        .font(Font.custom("Jost-Regular", size:20))
                        .foregroundStyle(Color.accentColor)
                }
            }
            .padding()
            .onAppear(){
                CLLocationManager().requestWhenInUseAuthorization()
            }
        }
        
    }
    
    func createListingRenting() async throws {
        var additionalListing: Int = 0
        var additionalPhoto: Int = 0
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        if listingType == "Rental" {
            listingLetter = "R"
        }else if listingType == "Auction" {
            listingLetter = "A"
        }else if listingType == "For Sale" {
            listingLetter = "B"
        }
        
        let document = try await Firestore.firestore().collection("carListings").document("\(listingLetter!)\(additionalListing)\(userID)").getDocument()
        
        if document.exists {
            additionalListing += 1
        }
        
        let document1 = try await Firestore.firestore().collection("carListings").document("\(listingLetter!)\(additionalListing)\(userID)").getDocument()
        
        if document1.exists {
            additionalListing += 1
        }
        
        let document2 = try await Firestore.firestore().collection("carListings").document("\(listingLetter!)\(additionalListing)\(userID)").getDocument()
        
        if document2.exists {
            errorText = "Users are only allowed to create three listings of each type"
        }
        
        date = Date.now
        
        try await db.collection("carListings").document("\(listingLetter!)\(additionalListing)\(userID)").setData([
                "carMake": carMake,
                "carModel": carModel,
                "carType": carType,
                "carYear": carYear,
                "userID": userID,
                "listingType" : "renting",
                "imageName" : "4.png",
                "listingPrice": listingPrice,
                "carDescription": carDescription,
                "listingID" : "\(listingLetter!)\(additionalListing)\(userID)",
                "dateCreated" : date,
                "usersLiked" : [],
                "listingTitle": "\(carYear) \(carMake) \(carModel) \(carType)"
                

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
            
            let path = "listingImages/\(additionalPhoto)\(listingLetter!)\(additionalListing)\(userID).jpeg"
            let fileRef = storageRef.child(path)
            
            
            fileRef.putData(imageData!, metadata: nil) { (metadata, error) in
                if error == nil && metadata != nil {
                    let ref = Storage.storage().reference(withPath: path)
                    ref.downloadURL { url, err in
                        if err == nil{
                            
                        }
                        guard let url = url else { return }
                        AuthenticationManager.shared.updateImage(imageURL: url.absoluteString,additionalListing: additionalListing, listingLetter: listingLetter!)
                    }
                }
            }
            additionalPhoto += 1
        }
    }
    
}
extension Image {
    @MainActor
    func getUIImage(newSize: CGSize) -> UIImage? {
        let image = resizable()
            .scaledToFill()
            .frame(width: newSize.width, height: newSize.height)
            .clipped()
        return ImageRenderer(content: image).uiImage
    }
}
#Preview {
    listingCreation(carType: "", location: "", carModel: "", carMake: "", carYear: "",  listingPrice: "", carDescription: "", showSignInView: .constant(false))
}



