//
//  OtherUserProfile.swift
//  carQuest
//
//  Created by Maddy Quinn on 1/10/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct OtherUserProfile: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: chatViewModel
    let carUser: CarQuestUser?
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                    dismiss()
                }, label: {
                    backButton()
                })
                Spacer()
            }
            HStack{
                WebImage(url: URL(string: vm.carUser?.profileImageURL ?? "profileIcon"))
                    .resizable()
                    .scaledToFill()
                    .frame(width:65, height:65)
                    .clipShape(Circle())
                Text(vm.carUser?.display_name ?? "$username")
                    .foregroundStyle(Color.foreground)
                    .font(Font.custom("ZingRustDemo-Base", size: 30))
                Spacer()
                }
            HStack{
                Text(vm.carUser?.description ?? "Hi, I'm new to Car Quest.")
                    .foregroundStyle(Color.foreground)
                    .font(Font.custom("Jost-Regular", size: 20))
                    .multilineTextAlignment(.leading)
            }
            HStack{
                Text(vm.carUser?.display_name ?? "$username" + "'s listings")
                    .foregroundStyle(Color.foreground)
                    .font(Font.custom("Jost-Regular", size: 20))
                Spacer()
            }
            Spacer()
        }.padding()
    }
}

//#Preview {
//    OtherUserProfile(vm: chatViewModel(carUser: carUser), carUser: carUser)
//}
