import SwiftUI
import Firebase
import SDWebImageSwiftUI

// list of users to create message
struct CreateNewMessage: View{
    
    let didSelectNewUser: (CarQuestUser?) -> ()
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm = CreateNewMessageViewModel()
    @State var userSearch = ""
    @State var createNewMessageIsPresented: Bool = false
    @Environment(\.dismiss) var dismiss

    var body: some View{
        NavigationView{
            VStack{
                HStack{
                    Text("Saved messages")
                        .font(Font.custom("ZingRustDemo-Base", size: 30))
                        .foregroundColor(Color.foreground)
                    Spacer()
                }
                if vm.savedUsers.isEmpty {
                    ScrollView(showsIndicators: false){
                        HStack{
                            Text("No saved users.")
                                .font(.custom("Jost", size: 18))
                                .foregroundColor(Color(.init(white:0.65, alpha:1)))
                            Spacer()
                        }
                    }
                } else {
                    ScrollView(showsIndicators: false){
                        ForEach(vm.savedUsers){ user in
                            Button{
                                presentationMode.wrappedValue.dismiss()
                                didSelectNewUser(user)
                            } label: {
                                recentMessageTextBox(carUser: user, pfp: user.profileImageURL, displayName: user.display_name, recentMessage: "Hello")
                            }
                        }
                    }
                    Divider()
                }
                
            }
            .fullScreenCover(isPresented: $createNewMessageIsPresented) {
                VStack{
                    HStack{
                        Text("Create new message")
                            .font(Font.custom("ZingRustDemo-Base", size: 30))
                            .foregroundColor(Color.foreground)
                        Spacer()
                        Button(action: {
                            dismiss()
                        }, label: {
                            Text("Cancel")
                                .underline()
                                .font(.custom("Jost-Regular", size: 17))
                        })
                    }
                    TextField("Search for a user...", text: $userSearch)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width:350, height:35)
                        .font(.custom("Jost-Regular", size: 20))
                    ScrollView(showsIndicators: false){
                        ForEach(vm.users.filter({ userSearch.isEmpty ? true : $0.display_name.localizedCaseInsensitiveContains(userSearch)})) { user in
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
                                        .foregroundColor(Color.foreground)
                                    Spacer()
                                }
                            }
                            Divider()
                        }
                    }
                }
                .padding()
            }
            .padding()
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        backButton()
                    })
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        createNewMessageIsPresented.toggle()
                    }, label: {
                        Image(systemName: "person.crop.circle.fill.badge.plus")
                            .resizable()
                            .frame(width:45, height:40)
                    })
                }
            }
            .onAppear{
                vm.fetchUsers()
                Task {
                    do {
                        try vm.fetchSavedUsers()
                    } catch {
                        
                    }
                }
            }
        }.background(Color.background)
    }
    
   
    }

#Preview {
    //MainChatView(showSignInView: .constant(false))
    CreateNewMessage(didSelectNewUser: {
        user in
        print(user?.email)
    })
}
