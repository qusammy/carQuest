//
//  SignInView.swift
//  carQuest
//
//  Created by Maddy Quinn on 8/27/24.
//  Additions by James Hollander

import SwiftUI

struct SignInView: View {
    
    @State var userEmail: String = ""
    @State var userPassword: String = ""

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
                                .foregroundColor(.accentColor)
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
            
            TextField("Email", text: $userEmail)
                .foregroundColor(Color("darkGrayFlip"))
                .frame(width:250, height:50)
                .font(.custom("Jost-Regular", size: 20))
                .background(Color("grayFlip"))
                .cornerRadius(50)
                .multilineTextAlignment(.center)
                .disableAutocorrection(true)
            SecureField("Password", text: $userPassword)
                .foregroundColor(Color("darkGrayFlip"))
                .frame(width:250, height:50)
                .font(.custom("Jost-Regular", size: 20))
                .background(Color("grayFlip"))
                .cornerRadius(50)
                .multilineTextAlignment(.center)
                .disableAutocorrection(true)
            Button{
                self.isBoxChecked.toggle()
            } label: {
                HStack{
                    ZStack{
                        image(Image(systemName: "square.fill"), show: isBoxChecked)
                            .foregroundColor(Color("Foreground"))
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
                    
                    
                    
                }, label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width:250, height:50)
                            .foregroundColor(Color(red: 1.0, green: 0.11372549019607843, blue: 0.11372549019607843))
                        Text("Sign In")
                            .font(.custom("Jost-Regular", size: 25))
                            .foregroundColor(Color("Background"))
                    }
                })
                HStack{
                    Text("Don't have an account?")
                        .font(.custom("Jost-Regular", size: 20))
                        .foregroundColor(Color("Foreground"))
                    Button(action: {
                        //bring to sign up page
                    }, label: {
                        
                            Text("Sign up")
                                .font(.custom("Jost-Regular", size: 20))
                                .underline()
                                .foregroundColor(.accentColor)
                        })
                    }
                }
            }
        Button(action: {
            //bring to Google Login
        }, label: {
            ZStack{
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color(hue: 1.0, saturation: 0.005, brightness: 0.927), lineWidth:5)
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
    func image (_ image: Image, show: Bool) -> some View {
            image
            .resizable()
            .tint(isBoxChecked ? .black : .black)
            .font(.system(size: 30))
            .scaleEffect(show ? 1 : 0)
            .frame(width:20, height: 20)
    }
}

#Preview {
    SignInView()
}
