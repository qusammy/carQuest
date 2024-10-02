//
//  Shared.swift
//  carQuest
//
//  Created by beraoud_981215 on 9/13/24.
//

import SwiftUI

struct LineDivider: View {
    var body: some View {
        VStack{
            RoundedRectangle(cornerRadius: 70)
                .frame(width:345, height:1)
        }
    }
}


struct BottomNavigationBar: View {
    @Binding var showSignInView: Bool
    var body: some View {
        HStack{
            Image("gavel")
                .resizable()
                .frame(width: 60, height:60)
            Image("rent")
                .resizable()
                .frame(width: 60, height:60)
            NavigationLink(destination: HomeView(showSignInView: $showSignInView)) {
                Image("home")
                    .resizable()
                    .frame(width: 60, height:60)

            }
            Image("buy")
                .resizable()
                .frame(width: 60, height:60)
            NavigationLink(destination: ProfileView(showSignInView: $showSignInView).navigationBarBackButtonHidden(true)) {
                Image("profileIcon")
                    .resizable()
                    .frame(width: 55, height:55)
            }
        }

    }
}
