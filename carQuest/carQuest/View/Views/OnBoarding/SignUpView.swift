//
//  SignUpView.swift
//  carQuest
//
//  Created by hollande_894789 on 9/26/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct SignUpView: View {
    @StateObject private var viewModelGoogle = AuthenticationViewModel()
    @StateObject private var viewModel = SignInEmailViewModel()
    
    @Binding var showSignInView: Bool
    @Binding var showLogOut: Bool
    var errorText: String = ""
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack{
            Spacer()
                .navigationBarBackButtonHidden(true)
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 90, height: 35)
                                    .foregroundColor(Color("appColor"))
                                HStack {
                                    Image(systemName: "arrow.left")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.white)
                                    Text("Back")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        )
                    }
                })
            Image("carQuestLogo")
                .resizable()
                .renderingMode(.original)
                .cornerRadius(30)
                .frame(width:100, height:100)
            Text("CARQUEST")
                .font(Font.custom("ZingRustDemo-Base", size:60))
                .foregroundColor(Color("Foreground"))
            Text("Login or Create Account")
                .font(Font.custom("Jost-Regular", size:30))
                .foregroundColor(Color("Foreground"))
            Text(viewModel.errorText)
                .font(Font.custom("Jost-Regular", size:20))
                .foregroundColor(Color("appColor"))
            TextField("Email", text: $viewModel.email)
                .frame(width:250, height:50)
                .font(.custom("Jost-Regular", size: 20))
                .background(Color("grayFlip"))
                .cornerRadius(50)
                .multilineTextAlignment(.center)
                .disableAutocorrection(true)
                .autocapitalization(.none)
            SecureField("Password", text: $viewModel.password)
                .frame(width:250, height:50)
                .font(.custom("Jost-Regular", size: 20))
                .background(Color("grayFlip"))
                .cornerRadius(50)
                .multilineTextAlignment(.center)
                .disableAutocorrection(true)
                .autocapitalization(.none)
            }
            VStack{
                Button(action: {
                    Task {
                        do {
                            try await viewModel.signUp()
                            showSignInView = false
                            showLogOut = true
                        }catch {
                            if viewModel.email.isEmpty {
                                viewModel.errorText = "Please provide a valid email."
                            }else if viewModel.password.isEmpty {
                                viewModel.errorText = "Password must have at least 6 characters."
                            }else {
                                viewModel.errorText = "This email address is already being used by another account."
                            }
                        }
                    }
                }, label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width:250, height:50)
                            .foregroundColor(Color("appColor"))
                        Text("Sign Up")
                            .font(.custom("Jost-Regular", size: 25))
                            .foregroundColor(.white)
                    }
                })
                .onSubmit {
                    showLogOut = true
                }
                
                Button(action: {
                    Task {
                        do {
                            try await viewModelGoogle.googleSignIn()
                        }catch {
                            print(error)
                        }
                    }
                }, label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color("grayFlip"))
                            .frame(width:250, height:75)
                        HStack{
                            Image("googleIcon")
                                .resizable()
                                .frame(width:40, height:40)
                            Text("Sign up with Google")
                                .font(.custom("Jost-Regular", size: 20))
                                .foregroundColor(Color("Foreground"))
                        }
                    }
                })
            }
        }
    }
    func image (_ image: Image, show: Bool) -> some View {
        image
            .resizable()
            .font(.system(size: 30))
            .scaleEffect(show ? 1 : 0)
            .frame(width:20, height: 20)
    }
    

    


#Preview {
    SignUpView(showSignInView: .constant(false), showLogOut: .constant(false))
}
