// We Are in james branch
//  ContentView.swift
//  carQuest
//
//  Created by Maddy Quinn on 8/19/24.
//  Additions by James Hollander
// when navigation view, use .navigationViewStyle(StackNavigationViewStyle()) at the last bracket
import SwiftUI

struct ContentView: View {
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
                RoundedRectangle(cornerRadius: 70)
                    .frame(width:345, height:1)
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
                        HStack{
                           
                        }
                    }
                    .frame(width:375)
                }
                
                RoundedRectangle(cornerRadius: 70)
                    .frame(width:345, height:1)
                HStack{
                    Image("gavel")
                        .resizable()
                        .frame(width: 60, height:60)
                    Image("rent")
                        .resizable()
                        .frame(width: 60, height:60)
                    Image("home")
                        .resizable()
                        .frame(width: 60, height:60)
                    Image("buy")
                        .resizable()
                        .frame(width: 60, height:60)
                    NavigationLink(destination: SignInView()) {
                        Image("profileIcon")
                            .resizable()
                            .frame(width: 55, height:55)
                    }
                }
            }/*.offset(x:0,y:280)*/
            .padding()
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ContentView()
}

struct imageBox: View {
    var imageName: String
    var body: some View {
        VStack{
            Image(imageName)
                .resizable()
                .frame(width:200, height:200)
                .clipped()
        }
    }
}
