import SwiftUI
import Firebase
import FirebaseAuth
import SDWebImageSwiftUI
class chatViewModel: ObservableObject {
    
    @Published var chatText = ""
    @Published var errorMessage = ""
    let db = Firestore.firestore()

    let carUser: CarQuestUser?
    @ObservedObject var vm = UserProfileViewModel()

    init(carUser: CarQuestUser?) {
        self.carUser = carUser
    }
    func handleSend2(text: String) {
        print(chatText)
        
        let fromID = FirebaseManager.shared.auth.currentUser?.uid
        
        guard let toID = vm.carUser?.uid else { return }
        
        db.collection("messages").addDocument(data: ["fromID" : fromID ?? "", "toID": vm.carUser?.uid ?? "", "text": self.chatText])
    }
}
struct ChatView: View {
    
    let carUser: CarQuestUser?
    
    init(carUser: CarQuestUser?){
        self.carUser = carUser
        self.chatVm = .init(carUser: carUser)
    }
    
    @ObservedObject var vm = UserProfileViewModel()
    @ObservedObject var chatVm: chatViewModel
    
    var body: some View {
        VStack{
            ScrollView{
                Text("Keep your messages appropriate. You can always report another user by going to their profile and clicking 'Report'")
                    .font(Font.custom("Jost-Regular", size: 15))
                    .foregroundColor(Color(.init(white:0.65, alpha:1)))
                    .lineLimit(3)
                    .multilineTextAlignment(.center)
                    .frame(width:300)
                ForEach(0..<15){ num in
                    HStack{
                        Spacer()
                        HStack{
                           
                            Text("FAKE MESSAGE")
                                .font(Font.custom("Jost-Regular", size: 15))
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(25)
                        WebImage(url: URL(string: vm.carUser?.profileImageURL ?? ""))
                            .resizable()
                            .scaledToFill()
                            .frame(width:35, height:35)
                            .clipShape(Circle())
                    }
                    .padding(.horizontal)
                }
                HStack{ Spacer() }
                Text(chatVm.errorMessage)
                    .font(Font.custom("Jost-Regular", size: 15))
                    .foregroundColor(Color(.init(white:0.65, alpha:1)))
                    .lineLimit(3)
                    .multilineTextAlignment(.center)
                    .frame(width:300)
            }
            .background(Color(.init(white:0.95, alpha:1)))
            HStack(spacing:16){
                Button(action: {
                    
                }, label: {
                    Image(systemName:"photo.fill.on.rectangle.fill")
                        .resizable()
                        .foregroundColor(Color.accentColor)
                        .frame(width:40, height:35)
                })
                
                TextField("Type a private message", text: $chatVm.chatText)
                    .autocorrectionDisabled(true)
                Button(action: {
                    chatVm.handleSend2(text: chatVm.chatText)
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


//    func handleSend(text: String){
//        print(chatText)
//        guard let fromID = Auth.auth().currentUser?.uid else { return }
//
//       guard let toID = carUser?.uid else { return }
//
//        FirebaseManager.shared.firestore.collection("messages")
//            .document(fromID)
//            .collection(toID)
//            .document()
//
//        let messageData = ["fromID" : fromID, "toID" : toID, "text": self.chatText, "timestamp" : Timestamp()] as [String : Any]
//
//        db.collection("messages").addDocument(data: messageData) { error in
//            if let error = error {
//                print(error)
//                self.errorMessage = "Failed to save message to Firestore: \(error)"
//                return
//            }
//        }
//    }
