//
//  MainMessagesView.swift
//  carQuest
//
//  Created by Maddy Quinn on 1/14/25.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct MainMessagesView: View {
    
    let didSelectNewUser: (CarQuestUser?) -> ()

    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var vm = CreateNewMessageViewModel()
    @ObservedObject var viewModel = UserProfileViewModel()

    var body: some View {
        NavigationStack{
            List{
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
                            VStack{
                                Text(user.display_name)
                                    .font(Font.custom("Jost-Regular", size: 23))
                                    .foregroundColor(Color.foreground)
                            }
                            Spacer()
                        }
                    }
                }
                
            }
            .listStyle(.plain)
        }
        .padding()
        .onAppear{
                vm.fetchUsers()
        }
    }
}


#Preview {
    MainMessagesView(didSelectNewUser: {
        user in
        print(user?.email)
    })
}
