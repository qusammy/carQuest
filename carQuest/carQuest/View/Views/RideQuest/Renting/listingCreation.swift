import SwiftUI
import CoreLocation
import PhotosUI
import FirebaseFirestore
import Combine
import FirebaseAuth
import FirebaseAnalytics
import FirebaseStorage
import SDWebImage
import SDWebImageSwiftUI
struct listingCreation: View {
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
    @State var imageURLs: [String] = [""]
    
    
    
    
    var body: some View {
        NavigationView{
            VStack{
                Button(action: {
                    dismiss()
                }, label: {
                    HStack{
                        backButton()
                        Spacer()
                    }
                })
                .navigationBarTitleDisplayMode(.inline)
                HStack{
                    Text("List a Vehicle")
                        .font(Font.custom("Jost-Regular", size:30))
                        .frame(maxWidth: 275, alignment: .leading)
                    
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
                Divider()
                ScrollView(showsIndicators:false){
                    HStack{
                        headline(headerText: "Year")
                        Spacer()
                    }
                    Picker("Select year of vehicle", selection: $carYear){
                        ForEach(years.reversed(), id: \.self) {
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
                    
                    HStack{
                        Text("Price")
                            .font(Font.custom("ZingRustDemo-Base", size:30))
                            .foregroundColor(.foreground)
                        Text("per day")
                            .font(.custom("Jost-Regular", size: 20))
                            .foregroundColor(Color(red: 0.723, green: 0.717, blue: 0.726))
                        Spacer()
                    }
                    listingTextField(carFactor: $listingPrice, textFieldText: "000.00")
                        .underline()
                        .keyboardType(.numberPad)
                    
                    HStack{
                        headline(headerText: "Location")
                        Spacer()
                    }
                    Group{
                            Text(location)
                                .font(.custom("Jost-Regular", size: 20))
                                .frame(maxWidth: 375, alignment: .leading)
                                .multilineTextAlignment(.leading)
                        Button(action: {
                            locationManager.checkLocationAuthorization()
                            locationManager.update()
                            location = "\(locationManager.city), \(locationManager.state)"
                        }, label: {
                            Text("Request location")
                                .font(.custom("Jost-Regular", size: 20))
                                .frame(maxWidth: 375, alignment: .leading)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(Color(red: 1.0, green: 0.11372549019607843, blue: 0.11372549019607843))
                        })
                    }
                    HStack{
                        headline(headerText: "Photos")
                        Spacer()
                    }
                    Text("CarQuest recommends you upload photos with a 1:1 ratio.")
                        .font(.custom("Jost-Regular", size: 15))
                        .foregroundColor(Color(red: 0.723, green: 0.717, blue: 0.726))
                        .frame(maxWidth: 375, alignment: .leading)
                        .multilineTextAlignment(.leading)
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width:200, height:200)
                                    .foregroundColor(Color(hue: 1.0, saturation: 0.005, brightness: 0.927))
                                if imageURLs.isEmpty == false {
                                    WebImage(url: URL(string: imageURLs[0]))
                                        .resizable()
                                        .scaledToFill()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 200, height: 200)
                                        .clipped()
                                        .opacity(0.5)
                                    if imageURLs.count > 1 {
                                        Text("+\(imageURLs.count - 1)")
                                            .frame(width: 30, height: 30)
                                            .font(.custom("Jost-Regular", size: 15))
                                            .foregroundStyle(Color.white)
                                            .background(Color.blue)
                                            .clipShape(Circle())
                                            .offset(x: 75, y: 75)
                                    }
                                }
                                else if previewImages.isEmpty != true {
                                    Image(uiImage: previewImages[0])
                                        .resizable()
                                        .scaledToFill()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 200, height: 200)
                                        .clipped()
                                        .opacity(0.5)
                                    if previewImages.count > 1{
                                        Text("+\(previewImages.count - 1)")
                                            .frame(width: 30, height: 30)
                                            .font(.custom("Jost-Regular", size: 15))
                                            .foregroundStyle(Color.white)
                                            .background(Color.blue)
                                            .clipShape(Circle())
                                            .offset(x: 75, y: 75)
                                    }
                                }
                                PhotosPicker("Select image", selection: $photoItem1, matching: .images)
                                    .font(.custom("Jost-Regular", size:20))
                                    .foregroundColor(Color.foreground)
                                    .onAppear {
                                        for item in imageURLs {
                                            let url = URL(string: item)
                                            if url != nil {
                                                guard let imageData = try? Data(contentsOf: url!) else { return }
                                                selectedImages.append(imageData)
                                            }
                                        }
                                    }
                            }
                            .onChange(of: photoItem1) {
                                Task {
                                    selectedImages.removeAll()
                                    previewImages.removeAll()
                                    imageURLs.removeAll()
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
                                            if previewImages.contains(uiImage!) == false {
                                                previewImages.append(uiImage!)
                                            }
                                        } else {
                                            print("Failed")
                                        }
                                    }
                                    
                                }
                            }
                        }
                    }
                    
                    Text(errorText)
                        .font(Font.custom("Jost-Regular", size:20))
                        .frame(maxWidth: 275)
                        .foregroundStyle(Color.blue)
                    Button {
                        if carMake != "" || carModel != "" || carType != "" || listingPrice != "" {
                            Task{
                                do{
                                    try await createListingRenting(listingExists: editListing, listingName: listingName ?? "")
                                    photo1Data = Data()
                                    showError = false
                                    dismiss()
                                    carViewModel.generateRentListings()
                                    errorText = ""
                                }catch {
                                    showError.toggle()
                                }
                            }
                        }else {
                            errorText = "Car make, model, type, and listing price are required fields!"
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(maxWidth:150, maxHeight:100)
                                .foregroundColor(Color(red: 1.0, green: 0.11372549019607843, blue: 0.11372549019607843))
                            Text("Save")
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
            }.padding()
        }
    }
    func createListingRenting(listingExists: Bool, listingName: String) async throws {
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
            "listingType" : "renting",
            "imageName" : "https://firebasestorage.googleapis.com/v0/b/carquest-4038a.appspot.com/o/4.png?alt=media&token=d79fb423-974c-4b7c-87ac-0dd495ab66e5",
            "listingPrice": listingPrice,
            "carDescription": carDescription,
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
    listingCreation(editListing: false, carType: "", location: "", carModel: "", carMake: "", carYear: "", listingPrice: "", carDescription: "", showSignInView: .constant(false))
}
