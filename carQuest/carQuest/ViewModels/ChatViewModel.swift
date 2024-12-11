//
//  ChatViewModel.swift
//  carQuest
//
//  Created by Maddy Quinn on 11/22/24.
//

import Foundation
import SDWebImageSwiftUI
import Firebase
import SwiftUI

struct FirebaseConstants{
    static let fromId = "fromId"
    static let toId = "toId"
    static let text = "text"

}

struct ChatMessage: Identifiable {
    
    var id: String { documentId }
    
    let documentId: String
    let fromId, toId, text, display_name, profileImageURL: String
    let timestamp: Date
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }

    init(documentId: String, data: [String : Any]) {
        self.documentId = documentId
        self.fromId = data[FirebaseConstants.fromId] as? String ?? ""
        self.toId = data[FirebaseConstants.toId] as? String ?? ""
        self.text = data[FirebaseConstants.text] as? String ?? ""
        self.display_name = data["display_name"] as? String ?? ""
        self.profileImageURL = data["profileImageURL"] as? String ?? ""
        self.timestamp = data["timestamp"] as? Date ?? Date()


    }
}

class chatViewModel: ObservableObject {
    @Published var chatText = ""
    @Published var errorMessage = ""
    
    @Published var chatMessages = [ChatMessage]()
    @ObservedObject var userVM = UserProfileViewModel()

    @Published var carUser: CarQuestUser?
    
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
                DispatchQueue.main.async {
                    self.count += 1
                }
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
            
            self.persistRecentMessage()
            self.persistRecipientMessage(fromIdDisplayName: self.userVM.carUser?.display_name ?? "", fromIdProfilePic: self.userVM.carUser?.profileImageURL ?? "")

            self.chatText = ""
            self.count += 1
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
    private func persistRecipientMessage(fromIdDisplayName: String, fromIdProfilePic: String){

        guard let carUser = carUser else { return }
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = self.carUser?.user_id else { return }
        
        let document = FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(toId)
            .collection("recipientMessages")
            .document(fromId)
        
        let recipientData = [
            "timestamp": Timestamp(),
            FirebaseConstants.text: self.chatText,
            FirebaseConstants.fromId: fromId,
            FirebaseConstants.toId: toId,
            "display_name": fromIdDisplayName,
            "profileImageURL": fromIdProfilePic
    
        ] as [ String : Any ]
        
        document.setData(recipientData) { error in
            if let error = error {
                self.errorMessage = "Failed to save recipient recent message"
                print(error)
                return
            }
        }
    }
    private func persistRecentMessage(){
        guard let carUser = carUser else { return }
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = self.carUser?.user_id else { return }
        
        let document = FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(fromId)
            .collection("messages")
            .document(toId)
        
        let data = [
            "timestamp": Timestamp(),
            FirebaseConstants.text: self.chatText,
            FirebaseConstants.fromId: fromId,
            FirebaseConstants.toId: toId,
            "profileImageURL": carUser.profileImageURL,
            "display_name": carUser.display_name
        ] as [ String : Any ]
        
        document.setData(data) { error in
            if let error = error {
                self.errorMessage = "\(error)"
                print(error)
                return
            }
        }
    }
    
    @Published var count = 0
}

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

struct ChatLogs: View {
    let message: ChatMessage
    let carUser: CarQuestUser?

    @ObservedObject var vm: chatViewModel
    @ObservedObject var userVM = UserProfileViewModel()
    var body: some View {
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
}

struct recentMessageTextBox: View{
    @State var carUser: CarQuestUser?
    @ObservedObject var vm = CreateNewMessageViewModel()
    var body: some View {
        NavigationLink(destination: ChatView(carUser: carUser)){
            VStack(alignment: .leading){
                HStack{
                    Image("profileIcon")
                        .resizable()
                        .frame(width:60, height:60)
                    VStack{
                        Text("recentMessage.display_name")
                            .font(Font.custom("Jost-Regular", size:25))
                            .foregroundColor(.black)
                        Text("recent message")
                            .font(Font.custom("Jost-Regular", size:17))
                            .foregroundColor(Color(red: 0.723, green: 0.717, blue: 0.726))
                    }
                }
                Divider()
            }
        }
    }
}
