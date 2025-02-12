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
    @State private var showingDeleteAlert: Bool = false
    @State private var showingSignOutAlert: Bool = false
    @State private var showingVerifyAlert: Bool = false
    @State private var showingVerifyButton: Bool = true
    // Variables to navigate to a different setting
    @State var showNewMessageScreen = false
    @State var shouldNavigateToSettingView = false
    @State private var errorText = ""
    var body: some View {
        NavigationView{
            VStack {
                VStack {
                    List {
                        if showSignInView == false {
                            if let user = viewModel.user {
                                Text("User ID: \(user.userId)")
                            }
                            NavigationLink(destination: UserProfileView(showSignInView: $showSignInView)){
                                Text("Profile")
                                    .font(.custom("Jost-Regular", size:20))
                                .foregroundColor(Color.foreground) }

                        
                        NavigateToSetting(destination: AnyView.init(MyListingsView( showSignInView: $showSignInView)), title: "Listings")
                        NavigateToSetting(destination: AnyView.init(PurchasesView(showSignInView: $showSignInView)), title: "Purchases & Payment")
                        NavigateToSetting(destination: AnyView.init(PushNotificationView(showSignInView: $showSignInView)), title: "Push Notifications")
                        NavigateToSetting(destination: AnyView.init(PrivacyView(showSignInView: $showSignInView)), title: "Privacy")
                        NavigateToSetting(destination: AnyView.init(AboutCarQuest(showSignInView: $showSignInView)), title: "About Car Quest")
                            if Auth.auth().currentUser?.isEmailVerified == false {
                                Button {
                                    Task {
                                        do {
                                            try await AuthenticationManager.shared.verifyEmail()
                                            showingVerifyAlert = true
                                        }catch {
                                            print(error)
                                        }
                                    }
                                }label: {
                                    Text("Verify Email")
                                        .foregroundStyle(Color("Foreground"))
                                }.alert ("Verify Email", isPresented: $showingVerifyAlert){
                                    Button("OK") {
                                        showingVerifyAlert = false
                                        showingVerifyButton = false
                                        Task {
                                            do {
                                                try await Auth.auth().currentUser?.reload()
                                            }catch {
                                                print("error reloading user")
                                            }
                                        }
                                        
                                    }
                                }message: {
                                    Text("You should have received an email with instructions on how to verify your email address.")
                                }
                            }
                        Button {
                            showingSignOutAlert = true
                            }label: {
                                Text("Log Out")
                                    .font(Font.custom("Jost-Regular", size: 20))
                                    .foregroundStyle(Color.accentColor)
                            }.alert("Are you sure you want to log out?", isPresented: $showingSignOutAlert) {
                        Button(role: .destructive) {
                                Task {
                                    do {
                                    try viewModel.signOut()
                                        showSignInView = true
                                    }catch {
                                        print(error)
                                            }
                                        }
                                }label: {
                                    Text("Log Out")
                                }
                            }
                        Button {
                            showingDeleteAlert = true
                            }label: {
                            Text("Delete Account")
                                .font(Font.custom("Jost-Regular", size: 20))
                                .foregroundColor(.accentColor)
                                }.alert("Are you sure you want to delete your account?", isPresented: $showingDeleteAlert) {
                                    Button(role: .destructive) {
                                        Task {
                                            do {
                                                try await viewModel.deleteAccount()
                                                showSignInView = true
                                            }catch {
                                                errorText = "This operation is sensitive and requires recent authentication. Log in again before retrying this request."
                                            }
                                        }
                                    }label: {
                                        Text("Delete Account")
                                            .font(Font.custom("Jost-Regular", size: 20))
                                    }
                                }message: {
                                    Text("This action cannot be undone. \n The info on this account will be unrecoverable")
                                }
                            }
                        Text(errorText)
                            .font(Font.custom("Jost-Regular", size: 20))
                            .foregroundColor(.blue)
                    }.padding()

                    }.task {
                        let currentUser = try? AuthenticationManager.shared.getAuthenticatedUser()
                        self.showSignInView = currentUser == nil
                        try? await viewModel.loadCurrentUser()
                        if Auth.auth().currentUser?.isEmailVerified == true {
                            showingVerifyButton = false
                        }
                    }   .foregroundColor(.accentColor)
                        .background(Color.background)
                        .scrollContentBackground(.hidden)
                        .listRowBackground(Color(.background))
                }
            }.navigationBarTitleDisplayMode(.inline)
        }
    }

#Preview {
    ProfileView(showSignInView: .constant(false))
}
