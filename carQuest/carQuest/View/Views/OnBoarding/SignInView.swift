//
//  SignInView.swift
//  carQuest
//
//  Created by Maddy Quinn on 8/27/24.
//  Additions by James Hollander

import SwiftUI
import FirebaseAuth

struct SignInView: View {
    @StateObject private var viewModelGoogle = AuthenticationViewModel()
    @StateObject private var viewModel = SignInEmailViewModel()

    @Binding var showSignInView: Bool
    @State private var resetPWisPresented: Bool = false
    @State private var signUpIsPresented: Bool = false
    
    
    var body: some View {
        VStack{
            Image("carQuestLogo")
                .resizable()
                .renderingMode(.original)
                .cornerRadius(30)
                .frame(width:100, height:100)
            Text("CARQUEST")
                .font(Font.custom("ZingRustDemo-Base", size:60))
                .foregroundColor(Color("Foreground"))
            Text("Sign In")
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
            VStack{
                Button(action: {
                    Task {
                        do {
                            try await viewModel.signIn()
                            let user = Auth.auth().currentUser
                            if user != nil {
                                showSignInView = false
                            }
                        }catch {
                            if viewModel.email.isEmpty {
                                viewModel.errorText = "Please provide a valid email."
                            }else if viewModel.password.isEmpty {
                                viewModel.errorText = "Password must have at least 6 characters."
                            }else {
                                viewModel.errorText = "Your email or password is incorrect."
                            }
                        }
                    }
                }, label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width:250, height:50)
                            .foregroundColor(Color("appColor"))
                        Text("Sign In")
                            .font(.custom("Jost-Regular", size: 25))
                            .foregroundColor(.white)
                    }
                })
                HStack {
                    Text("Forgot Password?")
                        .font(Font.custom("Jost-Regular", size:20))
                        .foregroundColor(Color("Foreground"))
                    Button {
                        resetPWisPresented.toggle()
                    }label: {
                        Text("Click Here!")
                            .font(Font.custom("Jost-Regular", size:20))
                            .foregroundColor(Color("appColor"))
                    }.fullScreenCover(isPresented: $resetPWisPresented, content: {
                        ResetPassword()
                    })
                }
                HStack {
                    Text("Don't have an account?")
                        .font(Font.custom("Jost-Regular", size:20))
                        .foregroundColor(Color("Foreground"))
                    Button {
                        signUpIsPresented.toggle()
                    }label: {
                        Text("Sign Up!")
                            .font(Font.custom("Jost-Regular", size:20))
                            .foregroundColor(Color("appColor"))
                    }
                    .fullScreenCover(isPresented: $signUpIsPresented, content: {
                        SignUpView(showSignInView: $showSignInView)
                    })
                }
                
                Button(action: {
                    Task {
                        do {
                            try await viewModelGoogle.googleSignIn()
                            showSignInView = false
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
                            Text("Sign in with Google")
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
    

    

}
#Preview {
    SignInView(showSignInView: .constant(false))
}
