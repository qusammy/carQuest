import SwiftUI
import Combine
import FirebaseAuth

struct PhoneLink: View {
    @Environment(\.dismiss) var dismiss
    @State private var tempPhoneNumber: String = ""
    @State var sent = false
    @State private var verificationId: String?
    @State private var code = ""
    
    
    var body: some View {
        VStack{
            Button(action: {
                dismiss()
            }, label: {
                HStack{
                    backButton()
                    Spacer()
                }
            })
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            Image("carQuestLogo")
                .resizable()
                .renderingMode(.original)
                .cornerRadius(30)
                .frame(width:100, height:100)
            Text("CARQUEST")
                .font(Font.custom("ZingRustDemo-Base", size:60))
                .foregroundColor(Color("Foreground"))
            Text("2-Factor Authentication")
                .font(Font.custom("Jost-Regular", size:30))
                .foregroundColor(Color("Foreground"))
            
            TextField("Enter a phone number...", text: $tempPhoneNumber)
                .keyboardType(.phonePad)
                .onReceive(Just(tempPhoneNumber)) { newValue in
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    if filtered != newValue {
                        self.tempPhoneNumber = filtered
                    }
                }
                .frame(width:250, height:50)
                .font(.custom("Jost-Regular", size: 20))
                .background(Color("grayFlip"))
                .cornerRadius(20)
            if sent == false {
                Button {
                    secondFactorSend()
                }label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width:250, height:50)
                            .foregroundColor(Color("appColor"))
                        Text("Send Code")
                            .font(.custom("Jost-Regular", size: 25))
                            .foregroundColor(.white)
                    }
                }
            }
            if sent == true {
                TextField("Enter verification code...", text: $code)
                    .keyboardType(.numberPad)
                    .padding()
                
                Button {
                    secondFactorReceive()
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width:250, height:50)
                            .foregroundColor(Color("appColor"))
                        Text("Submit")
                            .font(.custom("Jost-Regular", size: 25))
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
    
    func secondFactorSend() {
        var newPhoneNumber = ""
        if tempPhoneNumber.hasPrefix("+1") == false {
            newPhoneNumber = "+1\(tempPhoneNumber)"
        } else {
            newPhoneNumber = tempPhoneNumber
        }
        let user = Auth.auth().currentUser
        user?.multiFactor.getSessionWithCompletion({ (session, error) in
          // Send SMS verification code.
          PhoneAuthProvider.provider().verifyPhoneNumber(
            newPhoneNumber,
            uiDelegate: nil,
            multiFactorSession: session
          ) { (verificationId, error) in
              if let error = error {
                  print("Error sending message: \(error.localizedDescription)")
                  return
              }
              self.verificationId = verificationId
              self.sent = true
          }
        })
    }
    
    func secondFactorReceive() {
        let user = Auth.auth().currentUser
        guard let verificationId = verificationId else {return}
        // verificationId will be needed for enrollment completion.
        // Ask user for the verification code.
        let credential = PhoneAuthProvider.provider().credential(
          withVerificationID: verificationId,
          verificationCode: code)
        let assertion = PhoneMultiFactorGenerator.assertion(with: credential)
        // Complete enrollment. This will update the underlying tokens
        // and trigger ID token change listener.
          user?.multiFactor.enroll(with: assertion, displayName: user?.displayName) { (error) in
              if let error = error {
                  print("Error enrolling user: \(error.localizedDescription)")
                  return
              }
              print("Phone number successfully added!")
        }
    }
    
}

#Preview {
    PhoneLink()
}
