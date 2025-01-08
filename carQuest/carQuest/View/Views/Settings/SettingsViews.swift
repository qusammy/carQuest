//
//  SettingsViews.swift
//  carQuest
//
//  Created by Maddy Quinn on 12/11/24.
//

import Foundation
import SwiftUI

struct NavigateToSetting: View {
    
    @State var destination: AnyView
    @State var shouldNavigateToSettingView: Bool = false
    @State var title: String
    
    var body: some View {
        VStack{
            NavigationLink(destination: destination, isActive: $shouldNavigateToSettingView) {
                Text(title)
                    .font(.custom("Jost-Regular", size: 20))
                    .foregroundColor(Color.foreground)
            }
        }
    }
}

struct PushNotificationView: View {
    // to exit view
    @Binding var showSignInView: Bool

    // to toggle button
    @State var pushNotification: Bool = true
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack{
                
            }
        }
    }
}

struct MyListingsView: View {
    @Binding var showSignInView: Bool

    var body: some View {
        ScrollView{
            VStack{
                HStack{
                    Text("My Listings")
                        .font(Font.custom("ZingRustDemo-Base", size: 40))
                        .foregroundColor(Color.foreground)
                    Spacer()
                }
            }
        }
    }
}

struct AboutCarQuest: View {
    @Binding var showSignInView: Bool

    var body: some View {
        ScrollView{
            VStack{
                HStack{
                    Text("About Car Quest")
                        .font(Font.custom("ZingRustDemo-Base", size: 40))
                        .foregroundColor(Color.foreground)
                    Spacer()
                }
               Text("Hi")
            }.padding()
        }
    }
}

struct PrivacyView: View {
    @Binding var showSignInView: Bool
    
    var body: some View {
        ScrollView{
            VStack{
                HStack{
                    Text("Privacy")
                        .font(Font.custom("ZingRustDemo-Base", size: 40))
                        .foregroundColor(Color.foreground)
                    Spacer()
                }
            }.padding()
        }
    }
}

struct PurchasesView: View {
    @Binding var showSignInView: Bool

    var body: some View {
        ScrollView{
            VStack{
                HStack{
                    Text("Purchases & Payment")
                        .font(Font.custom("ZingRustDemo-Base", size: 40))
                        .foregroundColor(Color.foreground)
                    Spacer()
                }
            }.padding()
        }
    }
}

