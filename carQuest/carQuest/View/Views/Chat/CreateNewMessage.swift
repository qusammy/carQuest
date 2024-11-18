//
//  CreateNewMessage.swift
//  carQuest
//
//  Created by Maddy Quinn on 11/14/24.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

class CreateNewMessageViewModel: ObservableObject {
    
    @Published var users = [CarQuestUser]()
    @Published var errorMessage = ""
    func fetchUsers() {
        let db = Firestore.firestore()
        
        db.collection("users").getDocuments { snapshot, error in
            if error == nil {
                self.errorMessage = "Fetched users successfully."
                if let snapshot = snapshot{
                    
                    DispatchQueue.main.async {
                        self.users = snapshot.documents.map { d in
                            
                            return CarQuestUser(id: d.documentID,
                                display_name: d["display_name"] as? String ?? "",
                                email: d["email"] as? String ?? "",
                                user_id: d["user_id"] as? String ?? "",
                                profileImageURL: d["profileImageURL"] as? String ?? "")
                        }
                    }
                }
            } else {
                self.errorMessage = "Failed to fetch users."
            }
        }
    }
}
struct CreateNewMessage: View{
    
    let didSelectNewUser: (CarQuestUser?) -> ()
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm = CreateNewMessageViewModel()
    
    var body: some View{
        
        NavigationView{
            VStack{
                Text(vm.errorMessage)
                    .foregroundColor(Color(.init(white:0.65, alpha:1)))
                ScrollView{
                    ForEach(vm.users) { user in
                        Button{
                            presentationMode.wrappedValue.dismiss()
                            didSelectNewUser(user)
                        } label: {
                            HStack{
                                WebImage(url: URL(string: user.profileImageURL))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width:45, height:45)
                                    .clipShape(Circle())
                                Text(user.display_name)
                                    .font(Font.custom("Jost-Regular", size: 23))
                                    .foregroundColor(.black)
                                Spacer()
                            }
                        }
                        Divider()
                    }
                }.frame(maxWidth:375)
            }.toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Cancel")
                            .foregroundColor(Color.accentColor)
                            .font(Font.custom("Jost-Regular", size:20))
                    })
                } 
                ToolbarItem(placement: .navigationBarLeading){
                    Text("New Message")
                        .font(Font.custom("ZingRustDemo-Base", size: 40))
                        .foregroundColor(.black)
                }
            }
            .onAppear{
                vm.fetchUsers()
            }
        }
    }
}

#Preview {
    MainChatView(showSignInView: .constant(false))
//    CreateNewMessage(didSelectNewUser: {
//        user in
//        print(user.email)
//    })
}
