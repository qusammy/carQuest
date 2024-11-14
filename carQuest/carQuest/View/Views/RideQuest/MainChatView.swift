//
//  MainChatView.swift
//  carQuest
//
//  Created by Maddy Quinn on 11/6/24.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase

class CreateNewMessageViewModel: ObservableObject {
    @Published var users = [CarQuestUser2]()
    
    func fetchUsers() {
        let db = Firestore.firestore()
        
        db.collection("users").getDocuments { snapshot, error in
            if error == nil {
                if let snapshot = snapshot{
                    
                    DispatchQueue.main.async {
                        self.users = snapshot.documents.map { d in
                            
                            return CarQuestUser2(id: d.documentID,
                                display_name: d["display_name"] as? String ?? "",
                                email: d["email"] as? String ?? "",
                                user_id: d["user_id"] as? String ?? "",
                                profileImageURL: d["profileImageURL"] as? String ?? "")
                        }
                    }
                }

            } else {
               //code
            }

        }

    }
//    func fetchAllUsers(){
//        FirebaseManager.shared.firestore.collection("users").getDocuments{ documentsSnapshot, error in
//            if let error = error {
//                self.errorMessage = "Failed to fetch users error: \(error)"
//                print("Failed to fetch users error: \(error)")
//                return
//            }
//            documentsSnapshot?.documents.forEach({ snapshot in
//                let data = snapshot.data()
//                self.users.append(.init(data: data))
//            })
//            self.errorMessage = "Fetched users successfully."
//        }
//    }
}

struct MainChatView: View {
    
    @Binding var showSignInView: Bool
    
    @ObservedObject var vm = UserProfileViewModel()
    @State var showNewMessageScreen = false
    @State var shouldNavigateToChatView = false
    var body: some View {
        NavigationView{
            VStack{
                ScrollView{
                    VStack(alignment:.leading){
                        HStack{
                            Text("Recent Messages")
                                .font(Font.custom("ZingRustDemo-Base", size:40))
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.black)
                            Spacer()
                            Button(action: {
                                showNewMessageScreen.toggle()
                            }, label: {
                                Image(systemName:("person.crop.circle.fill.badge.plus"))
                                    .resizable()
                                    .frame(width:50, height:45)
                                    .foregroundColor(Color.accentColor)
                            })
                        }
                        recentMessageTextBox()
                        recentMessageTextBox()
                        recentMessageTextBox()
                        recentMessageTextBox()
                        recentMessageTextBox()
                        recentMessageTextBox()
                        recentMessageTextBox()
                        recentMessageTextBox()
                        recentMessageTextBox()
                        recentMessageTextBox()
                        recentMessageTextBox()
                        
//                        NavigationLink("", isActive: $shouldNavigateToChatView){
//                            ChatView(carUser: self.carUser)
//                        }
                    }.frame(maxWidth:370)
                }
                bottomNavigationBar(showSignInView: $showSignInView)
            }
        }
//        .fullScreenCover(isPresented: $showNewMessageScreen){
//            CreateNewMessageView(didSelectNewUser: { user in
//                print(user.display_name)
//                self.shouldNavigateToChatView.toggle()
//                self.carUser = user
//            })
//        }
    }
    @State var carUser: CarQuestUser2?
}


struct CreateNewMessageView: View{
    
    let didSelectNewUser: (CarQuestUser2) -> ()
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm = CreateNewMessageViewModel()
    
    var body: some View{
        NavigationView{
            VStack{
            Text("")
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
                                Text(user.email)
                                    .font(Font.custom("Jost-Regular", size: 23))
                                    .foregroundColor(.black)
                            }
                        }
                        Divider()
                    }
                }
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
        }
    } 
//    init(){
//        vm.fetchUsers()
//    }
}
#Preview {
    MainChatView(showSignInView: .constant(false))
}


