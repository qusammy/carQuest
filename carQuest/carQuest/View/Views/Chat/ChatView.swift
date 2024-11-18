import SwiftUI
import Firebase
import FirebaseAuth
import SDWebImageSwiftUI

struct FirebaseConstants{
    static let fromId = "fromId"
    static let toId = "toId"
    static let text = "text"

}

struct ChatMessage: Identifiable {
    
    var id: String { documentId }
    
    let documentId: String
    let fromId, toId, text: String
    
    init(documentId: String, data: [String : Any]) {
        self.documentId = documentId
        self.fromId = data[FirebaseConstants.fromId] as? String ?? ""
        self.toId = data[FirebaseConstants.toId] as? String ?? ""
        self.text = data[FirebaseConstants.text] as? String ?? ""
    }
}

class chatViewModel: ObservableObject {
    @Published var chatText = ""
    @Published var errorMessage = ""
    
    @Published var chatMessages = [ChatMessage]()
    
    let carUser: CarQuestUser?
    
    init(carUser: CarQuestUser?){
        self.carUser = carUser
        
        fetchMessages()
    }
    func fetchMessages(){
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        guard let toId = carUser?.user_id else { return }
        
        FirebaseManager.shared.firestore.collection("messages").document(fromId)
            .collection(toId)
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen to messages"
                    print(error)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                       let data = change.document.data()
                        self.chatMessages.append(.init(documentId: change.document.documentID, data: data))
                    }
                })
            }
    }
    func handleSend(){
        print(chatText)
        
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        guard let toId = carUser?.user_id else { return }
        
        let document = FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .document()
        
        let messageData = [FirebaseConstants.fromId : fromId, FirebaseConstants.toId : toId, FirebaseConstants.text : self.chatText, "timestamp" : Timestamp()] as [String : Any]
        document.setData(messageData) { error in
            if let error = error {
                self.errorMessage = "Failed to save message \(error)"
                return
            }
            print("Successfully saved current user message")
            self.chatText = ""
        }
        let recipientMessageDoc = FirebaseManager.shared.firestore
            .collection("messages")
            .document(toId)
            .collection(fromId)
            .document()
        recipientMessageDoc.setData(messageData) { error in
            if let error = error {
                self.errorMessage = "Failed to save message \(error)"
                return
            }
            print("Successfully saved recipient user message")

        }
    }
}
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
                Text("Keep your messages appropriate. You can always report another user by going to their profile and clicking 'Report'")
                    .font(Font.custom("Jost-Regular", size: 15))
                    .foregroundColor(Color(.init(white:0.65, alpha:1)))
                    .lineLimit(3)
                    .multilineTextAlignment(.center)
                    .frame(width:300)
                ForEach(vm.chatMessages) { message in
                    VStack{
                        if message.fromId == FirebaseManager.shared.auth.currentUser?.uid {
                            HStack{
                                Spacer()
                                HStack{
                                    Text(message.text)
                                        .font(Font.custom("Jost-Regular", size: 15))
                                        .foregroundColor(.white)
                                }
                                .padding()
                                .background(Color.accentColor)
                                .cornerRadius(25)
                                WebImage(url: URL(string: userVM.carUser?.profileImageURL ?? "profileIcon"))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width:35, height:35)
                                    .clipShape(Circle())
                            }
                            .padding(.horizontal)
                        } else {
                            HStack{
                                WebImage(url: URL(string: vm.carUser?.profileImageURL ?? "profileIcon"))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width:35, height:35)
                                    .clipShape(Circle())
                                HStack{
                                    Text(message.text)
                                        .font(Font.custom("Jost-Regular", size: 15))
                                        .foregroundColor(.black)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(25)
            
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                HStack{ Spacer() }
                Text("")
                    .font(Font.custom("Jost-Regular", size: 15))
                    .foregroundColor(Color(.init(white:0.65, alpha:1)))
                    .lineLimit(3)
                    .multilineTextAlignment(.center)
                    .frame(width:300)
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
