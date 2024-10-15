//
//  ProfileView.swift
//  carQuest
//
//  Created by beraoud_981215 on 9/13/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    
    @StateObject private var nameViewModel = SignInEmailViewModel()
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    @State private var showingAlert: Bool = false
    
    
    var body: some View {
        NavigationView{
            VStack {
                topNavigationBar()
                VStack {
                    if showSignInView == true {
                        NavigationLink(destination: SignInView(showSignInView: $showSignInView)){
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
                    List{
                        
                        //settings go here e.g. dark mode
                        if showLogOut == true {
                            NavigationLink(destination: UserProfileView(showSignInView: .constant(false))){
                                Text("Profile")
                                    .font(.custom("Jost-Regular", size:20))
                                    .foregroundColor(.black)
                                }
                            Text("App Appearance")
                                .font(.custom("Jost-Regular", size:20))
                                .foregroundColor(.black)
                            Text("Privacy")
                                .font(.custom("Jost-Regular", size:20))
                                .foregroundColor(.black)
                    List {
                        
                        if showSignInView == false {
                            
                            if let user = viewModel.user {
                                Text("UserId: \(user.userId)")
                            }
                            
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
                            Button {
                                showingAlert = true
                            }label: {
                                Text("Delete Account")
                                    .foregroundColor(.accentColor)
                            }.alert("Are you sure you want to delete your account?", isPresented: $showingAlert) {
                                Button(role: .destructive) {
                                    Task {
                                        do {
                                            try await viewModel.deleteAccount()
                                            showSignInView = true
                                        }catch {
                                            print(error)
                                        }
                                    }
                                }label: {
                                    Text("Delete Account")
                                        .font(.custom("Jost-Regular", size: 25))
                                }
                            }message: {
                                Text("This action cannot be undone. \n The info on this account will be unrecoverable")
                            }
                        }
                        }
                }.onAppear {
                    }
                }.task {
                    let currentUser = try? AuthenticationManager.shared.getAuthenticatedUser()
                    self.showSignInView = currentUser == nil
                    try? await viewModel.loadCurrentUser()
                
                }
                .foregroundColor(.accentColor)
                .background(Color.background)
                .scrollContentBackground(.hidden)
                .listRowBackground(Color(.background))
                bottomNavigationBar(showSignInView: .constant(false))
            }
            .padding()
        }
    }
}

#Preview {
    ProfileView(showSignInView: .constant(false))
}
