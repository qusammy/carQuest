//
//  UserProfileView.swift
//  carQuest
//
//  Created by beraoud_981215 on 9/13/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorage

class FirebaseManager: NSObject{
    let auth: Auth
    let storage: Storage
    
    
    static let shared = FirebaseManager()
  
    override init() {
        
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        
        super.init()
    }
}

struct UserProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    @State var showLogOut: Bool = false
    
    @State var shouldShowImagePicker = false
    var body: some View {
        VStack{
           
            topNavigationBar()
            ScrollView{
                if let image = self.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width:200, height:200)
                        .clipShape(Circle())
                } else {
                    Image("profileIcon")
                        .resizable()
                        .frame(width:200, height:200)
                }
                Button(action: {
                    shouldShowImagePicker.toggle()
                }, label: {
                    Text("Change picture")
                        .font(.custom("Jost-Regular", size: 15))
                        .foregroundColor(Color("appColor"))
                })
                Text("User details")
                    .font(.custom("Jost-Regular", size:35))
                    .foregroundColor(.black)
                
                Text("$username")
                    .font(.custom("Jost-Regular", size:25))
                    .foregroundColor(.black)
                Text("$email")
                    .font(.custom("Jost-Regular", size:25))
                    .foregroundColor(.black)
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
            bottomNavigationBar(showSignInView: .constant(false))
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
            }
            
            ref.downloadURL { url, err in
                print("failed to download URL")
            }
            print("URL downloaded")
        }
    }
}

#Preview {
    UserProfileView(showSignInView: .constant(false))
}
