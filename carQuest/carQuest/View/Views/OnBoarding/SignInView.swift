//
//  SignInView.swift
//  carQuest
//
//  Created by Maddy Quinn on 8/27/24.
//  Additions by James Hollander

import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

struct GoogleSignInResultModel {
    let idToken: String
    let accessToken: String
}

@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    func googleSignIn() async throws{
        guard let topVC = Utilities.shared.topViewController() else {
            throw URLError(.cannotFindHost)
        }
        
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        guard let idToken: String = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        let accessToken: String = gidSignInResult.user.accessToken.tokenString
                
        let tokens = GoogleSignInResultModel(idToken: idToken, accessToken: accessToken)
        try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
    }
}
struct SignInView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    
    @State var email: String = ""
    @State var password: String = ""
    @State private var isBoxChecked = false
    
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
            Text("Login to your account")
                .font(Font.custom("Jost-Regular", size:30))
                .foregroundColor(Color("Foreground"))
            
            TextField("Email", text: $email)                    .frame(width:250, height:50)
                .font(.custom("Jost-Regular", size: 20))
                .background(Color("grayFlip"))
                .cornerRadius(50)
                .multilineTextAlignment(.center)
                .disableAutocorrection(true)
                .autocapitalization(.none)
            SecureField("Password", text: $password)
                .frame(width:250, height:50)
                .font(.custom("Jost-Regular", size: 20))
                .background(Color("grayFlip"))
                .cornerRadius(50)
                .multilineTextAlignment(.center)
                .disableAutocorrection(true)
                .autocapitalization(.none)
            Button{
                self.isBoxChecked.toggle()
            } label: {
                HStack{
                    ZStack{
                        image(Image(systemName: "square.fill"), show: isBoxChecked)
                            .foregroundColor(Color("Foreground"))
                        image(Image(systemName: "checkmark.square"), show: isBoxChecked)
                            .foregroundColor(Color("Background"))
                        image(Image(systemName: "square"), show: !isBoxChecked)
                            .foregroundColor(Color("Foreground"))
                    }
                    Text("Remember me")
                        .font(.custom("Jost-Regular", size: 20))
                        .foregroundColor(Color("Foreground"))
                }
            }
            VStack{
                Button(action: {
                    login()
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
                
//                GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)){
//                    
//                }
                Button(action: {
                    Task {
                        do {
                            try await viewModel.googleSignIn()
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
                HStack{
                    Text("Don't have an account?")
                        .font(.custom("Jost-Regular", size: 20))
                        .foregroundColor(Color("Foreground"))
                    NavigationLink(destination: SignUpView()) {
                        Text("Sign up")
                            .font(.custom("Jost-Regular", size: 20))
                            .underline()
                            .foregroundColor(Color("appColor"))
                    }
                }
            }
        }
    }
    func image (_ image: Image, show: Bool) -> some View {
        image
            .resizable()
            .tint(isBoxChecked ? .black : .black)
            .font(.system(size: 30))
            .scaleEffect(show ? 1 : 0)
            .frame(width:20, height: 20)
    }
    
    func login() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    

}
#Preview {
    SignInView()
}
