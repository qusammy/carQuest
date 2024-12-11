import SwiftUI
import Firebase
import FirebaseAuth
import SDWebImageSwiftUI


struct ChatView: View {
    
    let carUser: CarQuestUser?
    
    init(carUser: CarQuestUser?){
        self.carUser = carUser
        self.vm = .init(carUser: carUser)
    }
    
    @ObservedObject var vm: chatViewModel
    @ObservedObject var userVM = UserProfileViewModel()
    
    var body: some View {
        VStack{
            ScrollView{
                ScrollViewReader { ScrollViewProxy in
                    Text("Keep your messages appropriate. You can always report another user by going to their profile and clicking 'Report'")
                        .font(Font.custom("Jost-Regular", size: 15))
                        .foregroundColor(Color(.init(white:0.65, alpha:1)))
                        .lineLimit(3)
                        .multilineTextAlignment(.center)
                        .frame(width:300)
                    ForEach(vm.chatMessages) { message in
                        ChatLogs(message: message, carUser: carUser, vm: vm)
                    }
                    HStack{ Spacer() }
                        .id("Empty")
                        .onReceive(vm.$count) { _ in
                            withAnimation(.easeOut(duration: 0.5)) {
                                ScrollViewProxy.scrollTo("Empty", anchor: .bottom)
                            }
                        }
                    Text("")
                        .font(Font.custom("Jost-Regular", size: 15))
                        .foregroundColor(Color(.init(white:0.65, alpha:1)))
                        .lineLimit(3)
                        .multilineTextAlignment(.center)
                        .frame(width:300)
                }
            }
            .background(Color(.init(white:0.95, alpha:1)))
            HStack(spacing:16){
                Button(action: {
                    //sending pictures
                }, label: {
                    Image(systemName:"photo.fill.on.rectangle.fill")
                        .resizable()
                        .foregroundColor(Color.accentColor)
                        .frame(width:40, height:35)
                })
                
                TextField("Type a private message", text: $vm.chatText)
                    .autocorrectionDisabled(true)
                Button(action: {
                    vm.handleSend()
                }, label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 25)
                            .frame(width:60, height:45)
                        Text("Send")
                            .foregroundColor(.white)
                            .font(.custom("Jost-Regular", size: 17))
                    }
                })
            }
            .padding(.horizontal)
        }
        .navigationTitle(carUser?.display_name ?? "$username")
        .navigationBarTitleDisplayMode(.inline)
    }
}
struct ChatView_Previews: PreviewProvider {
    static var previews: some View{
        NavigationView{
            MainChatView(showSignInView: .constant(false))
            
        }
    }
}
