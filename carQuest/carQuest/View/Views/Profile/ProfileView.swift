//
//  ProfileView.swift
//  carQuest
//
//  Created by beraoud_981215 on 9/13/24.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    @State var showLogOut: Bool = false
    
    var body: some View {
        NavigationView{
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
                VStack {
                    if showLogOut == false {
                        NavigationLink(destination: SignInView(showSignInView: $showSignInView, showLogOut: $showLogOut)){
                            ZStack{
                                RoundedRectangle(cornerRadius: 20)
                                    .frame(width:250, height:50)
                                    .foregroundColor(Color("appColor"))
                                Text("Sign In")
                                    .font(.custom("Jost-Regular", size: 25))
                                    .foregroundColor(.white)
                            }
                        }
                        .onTapGesture {
                            showSignInView = true
                        }
                    }
                    List {
                        //settings go here e.g. dark mode
                        
                        if showLogOut == true {
                            Button("Log Out") {
                                Task {
                                    do {
                                        try viewModel.signOut()
                                        showSignInView = true
                                    }catch {
                                        print(error)
                                    }
                                }
                            }
                        }
                    }
                }.onAppear {
                    let currentUser = try? AuthenticationManager.shared.getAuthenticatedUser()
                    self.showLogOut = currentUser != nil
                }

                .foregroundColor(.accentColor)
                .background(Color.background)
                .scrollContentBackground(.hidden)
                .listRowBackground(Color(.background))
                RoundedRectangle(cornerRadius: 70)
                    .frame(width:345, height:1)
                bottomNavigationBar(showSignInView: .constant(false))
            }/*.offset(x:0,y:280)*/
            .padding()
        }
    }
}

#Preview {
    ProfileView(showSignInView: .constant(false))
}
