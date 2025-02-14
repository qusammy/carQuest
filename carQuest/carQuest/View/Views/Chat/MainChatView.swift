import SwiftUI
import SDWebImageSwiftUI
import Firebase

struct MainChatView: View {
    
    @Binding var showSignInView: Bool

    @ObservedObject var vm = UserProfileViewModel()
    
    @State var showNewMessageScreen = false
    
    @State var shouldNavigateToChatView = false


    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView{
            VStack{
                VStack(alignment:.leading){
                    HStack{
                        Text("Messages")
                            .font(Font.custom("ZingRustDemo-Base", size:40))
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color.foreground)
                        Spacer()
                        NavigationLink("", isActive: $shouldNavigateToChatView){
                            ChatView(carUser: self.carUser)
                        }
                        Button(action: {
                            showNewMessageScreen.toggle()
                        }, label: {
                            Image(systemName:("person.crop.circle.fill.badge.plus"))
                                .resizable()
                                .frame(width:50, height:45)
                                .foregroundColor(Color.accentColor)
                        })
                    }
                }
                messagesView
            }.frame(width:375)
        }.fullScreenCover(isPresented: $showNewMessageScreen){
            CreateNewMessage(didSelectNewUser: { user
                in
                print(user?.email ?? "")
                self.shouldNavigateToChatView.toggle()
                self.carUser = user
            })
        }
    }
    private var messagesView: some View {
      
        return ScrollView{
            ForEach(vm.recentMessages) { message in
                VStack{
                    NavigationLink{
                        ChatView(carUser: self.carUser)
                    } label: {
                            HStack{
                                WebImage(url: URL(string: message.profileImageURL))
                                    .resizable()
                                    .frame(width: 55, height:55)
                                    .scaledToFill()
                                    .clipShape(Circle())
                            VStack{
                                Text(message.display_name)
                                    .font(Font.custom("Jost-Regular", size:25))
                                        .foregroundColor(Color.foreground)
                                Text(message.text)
                                    .font(Font.custom("Jost-Regular", size:17))
                                    .foregroundColor(Color(red: 0.723, green: 0.717, blue: 0.726))
                                   
                                }
                                Spacer()
                                Text(message.timeAgo)
                                    .font(Font.custom("Jost-Regular", size:17))
                                        .foregroundColor(.accentColor)
                            }
                        }
                }.frame(width:375)
                Divider()
                }
            Text("Recent messages will appear here.")
                .font(Font.custom("Jost-Regular", size: 15))
                .foregroundColor(Color(.init(white:0.65, alpha:1)))
                .lineLimit(3)
                .multilineTextAlignment(.center)
                .frame(width:300)
            }
        }
    @State var carUser: CarQuestUser?
}



#Preview {
    MainChatView(showSignInView: .constant(false))
}


