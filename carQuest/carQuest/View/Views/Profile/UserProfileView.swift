import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorage
import SDWebImageSwiftUI

class FirebaseManager: NSObject{
    
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    
    static let shared = FirebaseManager()
  
    override init() {
        
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
}

struct UserProfileView: View {
    @StateObject private var viewModelGoogle = AuthenticationViewModel()
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    @State var showLogOut: Bool = false
    
    @State var shouldShowImagePicker = false
    @ObservedObject var vm = UserProfileViewModel()
       
    @State private var descriptionEditor = false

    var body: some View {
        NavigationStack{
            VStack{
                Text("User details")
                    .font(.custom("Jost-Regular", size:35))
                    .foregroundColor(Color.foreground)
                HStack{
                    if let image = self.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width:200, height:200)
                            .clipShape(Circle())
                    } else if vm.carUser?.profileImageURL == nil {
                        Image("profileIcon")
                            .resizable()
                            .scaledToFill()
                            .frame(width:200, height:200)
                            .clipShape(Circle())
                    }
                    else {
                        WebImage(url: URL(string: vm.carUser?.profileImageURL ?? "profileIcon.png"))
                            .resizable()
                            .scaledToFill()
                            .frame(width:200, height:200)
                            .clipShape(Circle())
                    }
                }
                Button(action: {
                    shouldShowImagePicker.toggle()
                }, label: {
                    Text("Change picture")
                        .font(.custom("Jost-Regular", size: 15))
                        .foregroundColor(Color.accentColor)
                })
                
                List{
                    Text(vm.carUser?.display_name ?? "$username")
                        .font(.custom("Jost-Regular", size:25))
                        .foregroundColor(Color.foreground)
                    Text(vm.carUser?.email ?? "$email")
                        .font(.custom("Jost-Regular", size:25))
                        .foregroundColor(Color.foreground)
                    NavigationLink(destination: AddDescriptionView(), isActive: $descriptionEditor) {
                            Text(vm.carUser?.description ?? "$description")
                                .font(.custom("Jost-Regular", size:20))
                                .foregroundColor(Color.foreground)
                                .lineLimit(1)
                        }
                    
                    
                }.listStyle(.plain)
                if let user = vm.carUser {
                    Text("User ID: \(user.user_id)")
                        .font(.custom("Jost-Regular", size:15))
                        .foregroundColor(Color.foreground)
                } else {
                    HStack{
                        
                    }
                }
                Spacer()
                Button(action: {
                    persistImageToStorage()
                }, label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 35)
                            .frame(width:150, height:60)
                            .foregroundColor(Color(red: 1.0, green: 0.11372549019607843, blue: 0.11372549019607843))
                        Text("Save details")
                            .font(.custom("Jost-Regular", size: 25))
                            .foregroundColor(.white)
                    }
                })
            }
        }.onAppear{
            print(vm.carUser?.description ?? "default")
        }.padding()
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil){
            ImagePicker(image: $image)
        }
    }
    @State var image: UIImage?
    

    
    func persistImageToStorage(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid
        else { return }
        let ref =  FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                print("failed to push image to storage \(err)")
                return
            }
            ref.downloadURL { url, err in
                if err != nil {
                    print("failed to download URL")
                    return
                }
                print("URL downloaded")
                guard let url = url else { return }
                AuthenticationManager.shared.updateProfilePicture(photoURL: url)
            }
        }
    }
}
#Preview {
    UserProfileView(showSignInView: .constant(false))
}

struct AddDescriptionView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm = UserProfileViewModel()
    @State var userDescription: String = ""
    @State var wordLimit = 25
    var body: some View {
        VStack{
            HStack{
                Text("Write a description")
                    .font(Font.custom("ZingRustDemo-Base", size: 40))
                    .foregroundColor(Color.foreground)
                Spacer()
                }
            
            TextField("My epic description...", text: $userDescription)
                    .font(Font.custom("Jost-Regular", size: 25))
                    .foregroundColor(Color.foreground)
                    .textFieldStyle(.roundedBorder)
            Text(vm.carUser?.description ?? "")
                .font(Font.custom("Jost-Regular", size: 20))
                .foregroundColor(Color(red: 0.723, green: 0.717, blue: 0.726))
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.leading)
            
                Spacer()
            Divider()
        }.padding()
            .toolbar{
                ToolbarItem {
                    Button(action: {
                        updateUserDescription(userDescription: userDescription)
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
    func updateUserDescription(userDescription: String){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{
            return
        }
        
        let userDescriptionData = [
            "description": userDescription
        ]
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).setData(userDescriptionData, merge: true){ err in
                if let err = err {
                    print(err)
                    return
                }
            }
    }
}

