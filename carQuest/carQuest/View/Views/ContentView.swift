// We Are in james branch
//  ContentView.swift
//  carQuest
//
//  Created by Maddy Quinn on 8/19/24.
//  Additions by James Hollander
// when navigation view, use .navigationViewStyle(StackNavigationViewStyle()) at the last bracket
import SwiftUI
import FirebaseAuth



struct ContentView: View {
    
    @State private var isHeartFilled: Bool = false
    @Binding var showSignInView: Bool
    @StateObject var viewModel = SignInEmailViewModel()
        
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                    .navigationBarBackButtonHidden(true)
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
                        HStack {
                            if viewModel.displayName == "" {
                                Text("Welcome User!")
                                    .font(Font.custom("Jost", size:30))
                                    .foregroundColor(Color("Foreground"))
                            }else {
                                Text("Welcome \(viewModel.displayName)!")
                                    .font(Font.custom("Jost", size:30))
                                    .foregroundColor(Color("Foreground"))
                            }
                        }
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
                    NavigationLink(destination: rentView().navigationBarBackButtonHidden(true)) {
                        Image("rent")
                            .resizable()
                            .frame(width: 55, height:55)
                    }
                    NavigationLink(destination: ContentView(showSignInView: $showSignInView).navigationBarBackButtonHidden(true)) {
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
            }/*.offset(x:0,y:280)*/
            .padding()
        }.navigationViewStyle(StackNavigationViewStyle())
        .task {
            viewModel.getDisplayName()
        }
    }
}

#Preview {
    ContentView(showSignInView: .constant(false))
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
