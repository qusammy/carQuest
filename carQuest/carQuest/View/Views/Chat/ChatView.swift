import SwiftUI
import Firebase
import FirebaseAuth
import SDWebImageSwiftUI

// this is the actual chat log view
struct ChatView: View {
    
    let carUser: CarQuestUser?
    
    init(carUser: CarQuestUser?){
        self.carUser = carUser
        self.vm = .init(carUser: carUser)
    }
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: chatViewModel
    @ObservedObject var userVM = UserProfileViewModel()
    @State private var isSaved: Bool = false
    @State var user: String?
    @State private var isPresented = false

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
            .background(Color.chatBackground)
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
                            .foregroundStyle(Color.accentColor)
                        Text("Send")
                            .foregroundColor(.white)
                            .font(.custom("Jost-Regular", size: 17))
                    }
                })
            }
            .padding(.horizontal)
        }
        
        .toolbar{
            ToolbarItem(placement: .principal){
                    Text(carUser?.display_name ?? "$username")
                        .foregroundStyle(Color.foreground)
                        .font(Font.custom("Jost-Regular", size: 25))
                }
            ToolbarItem(placement: .topBarTrailing){
                Button {
                    isSaved.toggle()
                    Task{
                        do{
                            try await appendSavedChat(usersSaved: user ?? "", isSaved: isSaved, userID: carUser?.user_id ?? "")
                        }catch {
                            
                        }
                    }
                } label: {
                    Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                        .resizable()
                        .foregroundColor(.foreground)
                        .frame(width:20, height:25)
                }
            }

        }
        .onAppear{
            Task {
                do{
                    try await checkForSave()
                    user = try AuthenticationManager.shared.getAuthenticatedUser().uid
                } catch {
                    
                }
            }
        }
    }
    func appendSavedChat(usersSaved: String, isSaved: Bool, userID: String) async throws {
        let db = Firestore.firestore()
        let user = try AuthenticationManager.shared.getAuthenticatedUser().uid

        if isSaved == true {
            
            let usersSavedData = [
                "usersSaved": [usersSaved]
            ]
            
            try await FirebaseManager.shared.firestore.collection("users")
                .document(carUser?.user_id ?? "NO data").setData(usersSavedData, merge: true)
        }
        else {
            try await db.collection("users").document(carUser?.user_id ?? "").updateData([
                    "usersSaved": FieldValue.arrayRemove([user])
                ])
        }
    }
    func checkForSave() async throws {
        let db = Firestore.firestore()
        let user = try AuthenticationManager.shared.getAuthenticatedUser().uid
        
        do {
            let querySnapshot = try await db.collection("users").whereField("usersSaved", arrayContains: user)
                .getDocuments()
            for document in querySnapshot.documents {
                
                if carUser?.user_id == document.documentID {
                    isSaved = true
                }
            }
        } catch {
            print("Error getting documents: \(error)")
        }
    }
}
struct ChatView_Previews: PreviewProvider {
    static var previews: some View{
        NavigationView{
            MainChatView(showSignInView: .constant(false))
            
        }
    }
}
