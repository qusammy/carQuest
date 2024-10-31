//  Created by Maddy Quinn on 9/30/24.
//
import SwiftUI
import Combine
import Firebase
import FirebaseFirestore
struct rentView: View {
    @Binding var showSignInView: Bool
    
    var body: some View {
        NavigationView{
            VStack{
                Spacer()
                topNavigationBar()
                ScrollView(){
                    NavigationLink(destination: listingCreation(carType: "", location: "", carModel: "", carMake: "", carDescription:"", showSignInView: $showSignInView).navigationBarBackButtonHidden(true)){
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width:220, height:50)
                                .foregroundColor(Color("appColor"))
                            Text("List a Rental")
                                .foregroundColor(.white)
                                .font(.custom("Jost-Regular", size: 30))
                        }
                    }
                }
        bottomNavigationBar(showSignInView: $showSignInView)
            }.frame(width:375)
        }
    }
}
#Preview {
    rentView(showSignInView: .constant(false))
}
