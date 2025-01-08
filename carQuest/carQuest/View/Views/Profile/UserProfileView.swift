//
//  UserProfileView.swift
//  carQuest
//
//  Created by beraoud_981215 on 9/13/24.
//new packages:
// https://github.com/SDWebImage/SDWebImageSwiftUI.git

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
   
    var body: some View {
        VStack{
            ScrollView{
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
                Text("User details")
                    .font(.custom("Jost-Regular", size:35))
                    .foregroundColor(Color.foreground)
                Text(vm.carUser?.display_name ?? "$username")
                    .font(.custom("Jost-Regular", size:25))
                    .foregroundColor(Color.foreground)
                Text(vm.carUser?.email ?? "$email")
                    .font(.custom("Jost-Regular", size:25))
                    .foregroundColor(Color.foreground)
                if let user = viewModel.user {
                    Text("User ID: \(user.userId)")
                        .font(.custom("Jost-Regular", size:15))
                        .foregroundColor(Color.foreground)
                } else {
                    Text("No user logged in")
                        .font(.custom("Jost-Regular", size:15))
                        .foregroundColor(Color.foreground)
                }
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
        }.fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil){
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
