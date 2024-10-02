//
//  HomeView.swift
//  carQuest
//
//  Created by beraoud_981215 on 9/13/24.
//

import SwiftUI

struct HomeView: View {
    
    @State private var isHeartFilled: Bool = false
    @Binding var showSignInView: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                HStack{
                    Text("CARQUEST")
                        .font(Font.custom("ZingRustDemo-Base", size:50))
                        .foregroundColor(Color("Foreground"))
                    Spacer()
                    Image(systemName: "bell.fill")
                        .resizable()
                        .frame(width:30, height:30)
                        .foregroundColor(Color("Foreground"))
                }
                LineDivider()
                ScrollView{
                    VStack{
                        Text("Welcome, Guest!")
                            .font(Font.custom("Jost-Regular", size:30))
                        HStack{
                            Text("Recently viewed")
                                .font(Font.custom("Jost-Regular", size:20))
                            Spacer()
                            Text("See all")
                                .font(Font.custom("Jost-Regular", size:15))
                                .underline()
                        }
                        HStack{
                            imageBox(imageName: "carQuestLogo")
                            imageBox(imageName: "carExample")
                        }
                        HStack{
                            imageBox(imageName: "carQuestLogo")
                            imageBox(imageName: "carQuestLogo")
                        }
                        RoundedRectangle(cornerRadius: 70)
                            .frame(width:345, height:1)
                        HStack{
                            Text("Liked vehicles")
                                .font(Font.custom("Jost-Regular", size:20))
                            Spacer()
                            Text("See all")
                                .font(Font.custom("Jost-Regular", size:15))
                                .underline()
                        }
                    }
                    .frame(width:375)
                }
                
                LineDivider()
                BottomNavigationBar(showSignInView: $showSignInView)
            }/*.offset(x:0,y:280)*/
            .padding()
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}



