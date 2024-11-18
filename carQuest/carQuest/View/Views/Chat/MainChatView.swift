//
//  MainChatView.swift
//  carQuest
//
//  Created by Maddy Quinn on 11/6/24.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase

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
    
                    }.frame(maxWidth:370)
                }
                bottomNavigationBar(showSignInView: $showSignInView)
            }
        }.fullScreenCover(isPresented: $showNewMessageScreen){
            CreateNewMessage(didSelectNewUser: { user
                in
                print(user?.email ?? "")
                self.shouldNavigateToChatView.toggle()
                self.carUser = user
            })
        }
    }
    @State var carUser: CarQuestUser?
}

#Preview {
    MainChatView(showSignInView: .constant(false))
}


