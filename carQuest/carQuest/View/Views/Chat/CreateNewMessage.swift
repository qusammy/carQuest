import SwiftUI
import Firebase
import SDWebImageSwiftUI


struct CreateNewMessage: View{
    
    let didSelectNewUser: (CarQuestUser?) -> ()
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm = CreateNewMessageViewModel()
    @State private var userSearch = ""

    var body: some View{
        
        NavigationView{
            VStack{
                TextField("username", text: $userSearch)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width:350, height:35)
                    .font(.custom("Jost-Regular", size: 20))
                ScrollView{
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
                    Text(vm.errorMessage)
                        .foregroundColor(Color(.init(white:0.65, alpha:1)))
                }.padding()
            }.toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Cancel")
                            .foregroundColor(Color.accentColor)
                            .font(Font.custom("Jost-Regular", size:17))
                            .underline()
                    })
                } 
                ToolbarItem(placement: .navigationBarLeading){
                    Text("Messages")
                        .font(Font.custom("ZingRustDemo-Base", size: 40))
                        .foregroundColor(Color.foreground)
                }
            }
            .onAppear{
                vm.fetchUsers()
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
