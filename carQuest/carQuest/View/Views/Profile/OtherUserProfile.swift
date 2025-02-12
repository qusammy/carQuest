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
            ScrollView(showsIndicators: false){
                HStack{
                    WebImage(url: URL(string: vm.carUser?.profileImageURL ?? "profileIcon"))
                        .resizable()
                        .scaledToFill()
                        .frame(width:65, height:65)
                        .clipShape(Circle())
                    Text(vm.carUser?.display_name ?? "$username")
                        .foregroundStyle(Color.foreground)
                        .font(Font.custom("ZingRustDemo-Base", size: 35))
                    Spacer()
                }
                HStack{
                    Text(vm.carUser?.description ?? "Hi, I'm new to Car Quest.")
                        .foregroundColor(Color(red: 0.723, green: 0.717, blue: 0.726))
                        .font(Font.custom("Jost-Regular", size: 20))
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                Divider()
                HStack{
                    Text("\(vm.carUser?.display_name ?? "")'s listings")
                        .foregroundStyle(Color.foreground)
                        .font(Font.custom("Jost-Regular", size: 25))
                    Spacer()
                }
                Spacer()
            }
        }.padding()
    }
}

//#Preview {
//    OtherUserProfile(vm: chatViewModel(carUser: carUser), carUser: carUser)
//}
