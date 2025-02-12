//
//  ResetPassword.swift
//  carQuest
//
//  Created by hollande_894789 on 10/2/24.
//

import SwiftUI

struct ResetPassword: View {
    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel = SignInEmailViewModel()
    @State private var email: String = ""
    
    @State private var showingAlert = false
    
    var body: some View {
        HStack {
            Button {
                dismiss()
            }label: {
                backButton()
            }
            .padding()
            Spacer()
        }
        VStack{
            Spacer()
            Image("carQuestLogo")
                .resizable()
                .renderingMode(.original)
                .cornerRadius(30)
                .frame(width:100, height:100)
            Text("CARQUEST")
                .font(Font.custom("ZingRustDemo-Base", size:60))
                .foregroundColor(Color("Foreground"))
            Text(viewModel.errorText)
                .font(Font.custom("Jost-Regular", size:20))
                .foregroundColor(Color("appColor"))
            TextField("Email", text: $email)
                .frame(width:250, height:50)
                .font(.custom("Jost-Regular", size: 20))
                .background(Color("grayFlip"))
                .cornerRadius(50)
                .multilineTextAlignment(.center)
                .disableAutocorrection(true)
                .autocapitalization(.none)
            Button(action: {
                Task {
                    do {
                        try await viewModel.resetPassword(email: email)
                        showingAlert.toggle()
                        viewModel.errorText = ""
                        dismiss()
                    }catch {
                        viewModel.errorText = "There is no account using this email."
                    }
                }
            }, label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width:250, height:50)
                        .foregroundColor(Color("Foreground"))
                    Text("Reset Password")
                        .font(.custom("Jost-Regular", size: 25))
                        .foregroundColor(.white)
                }
            })
            Spacer()
        }
        .alert("Password Reset Email Sent", isPresented: $showingAlert) {
            
        } message: {
            Text("Please check your email and follow the steps to reset your password.")
        }
    }
}

#Preview {
    ResetPassword()
}
