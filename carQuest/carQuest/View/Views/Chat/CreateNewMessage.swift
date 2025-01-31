//
//  CreateNewMessage.swift
//  carQuest
//
//  Created by Maddy Quinn on 11/14/24.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI


struct CreateNewMessage: View{
    
    let didSelectNewUser: (CarQuestUser?) -> ()
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm = CreateNewMessageViewModel()
    
    var body: some View{
        
        NavigationView{
            VStack{
                Text(vm.errorMessage)
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
                                Text(user.display_name)
                                    .font(Font.custom("Jost-Regular", size: 23))
                                    .foregroundColor(Color.foreground)
                                Spacer()
                            }
                        }
                        Divider()
                    }
                }.frame(maxWidth:375)
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
