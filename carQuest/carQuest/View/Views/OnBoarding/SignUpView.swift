//
//  SignUpView.swift
//  carQuest
//
//  Created by hollande_894789 on 9/11/24.
//
import SwiftUI
import Firebase
import FirebaseAuth

struct SignUpView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    
//    @State var confirmPass: String = ""
    
//    @State var passMatch: Bool = false
//    @State var validUser: Bool = false
//    @State var errorText: String = ""

    @State private var isBoxChecked = false
    
    @Environment(\.presentationMode) private var presentationMode1: Binding<PresentationMode>
    
    var body: some View {
        VStack{
            Spacer()
            .navigationBarBackButtonHidden(true)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode1.wrappedValue.dismiss()
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
//            Text("\(errorText)")
                .font(Font.custom("Jost-Regular", size:20))
                .foregroundColor(Color("appColor"))
            Text("Create an account")
                    .font(Font.custom("Jost-Regular", size:30))
                    .foregroundColor(Color("Foreground"))
            
            TextField("Email", text: $email)                .frame(width:250, height:50)
                .font(.custom("Jost-Regular", size: 20))
                .background(Color("grayFlip"))
                .cornerRadius(50)
                .multilineTextAlignment(.center)
                .disableAutocorrection(true)
                .autocapitalization(.none)
            SecureField("Password", text: $password)                .frame(width:250, height:50)
                .font(.custom("Jost-Regular", size: 20))
                .background(Color("grayFlip"))
                .cornerRadius(50)
                .multilineTextAlignment(.center)
                .disableAutocorrection(true)
                .autocapitalization(.none)
//            SecureField("Confirm Password", text: $confirmPass)
//                .foregroundColor(Color("darkGrayFlip"))
//                .frame(width:250, height:50)
//                .font(.custom("Jost-Regular", size: 20))
//                .background(Color("grayFlip"))
//                .cornerRadius(50)
//                .multilineTextAlignment(.center)
//                .disableAutocorrection(true)
//                .autocapitalization(.none)
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
//                    signUpCheck()
//                    if validUser == true && passMatch == true && isBoxChecked == true {
//                        UserDefaults.standard.set(emailInput, forKey: "EMAIL")
//                        UserDefaults.standard.set(emailInput, forKey: "PASS")
//                        errorText = ""
//                    } else if validUser == false {
//                        errorText = "Invalid email"
//                    } else if passMatch == false {
//                        errorText = "Passwords do not match"
//                    }
                    register()
                    
                }, label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width:250, height:50)
                            .foregroundColor(Color("appColor"))
                        Text("Sign up")
                            .font(.custom("Jost-Regular", size: 25))
                            .foregroundColor(.white)
                    }
                })
            }
        }
        Button(action: {
            //bring to Google Login
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
    func image (_ image: Image, show: Bool) -> some View {
            image
            .resizable()
            .tint(isBoxChecked ? .black : .black)
            .font(.system(size: 30))
            .scaleEffect(show ? 1 : 0)
            .frame(width:20, height: 20)
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) {result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            
        }
    }
    
    
//    func signUpCheck () {
//        if confirmPass == passInput {
//            passMatch = true
//        }
//        if emailInput != "" {
//            validUser = true
//        }
//        
//    }
}
#Preview {
    SignUpView()
}
