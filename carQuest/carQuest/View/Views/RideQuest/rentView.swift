//  Created by Maddy Quinn on 9/30/24.
//
import SwiftUI
import Combine
import Firebase
import FirebaseFirestore


struct rentView: View {
    @Binding var showSignInView: Bool
    @State var userPreferences = ""
    
    var body: some View {
        NavigationStack{
            VStack{
                topNavigationBar(showSignInView: $showSignInView)
                HStack{
                    Text("Rental services")
                        .foregroundColor(Color.foreground)
                        .font(.custom("ZingRustDemo-Base", size: 35))
                    Spacer()
                    NavigationLink(destination: listingCreation(carType: "", location: "", carModel: "", carMake: "", carDescription:"", showSignInView: $showSignInView).navigationBarBackButtonHidden(true)){
                            ZStack{
                                RoundedRectangle(cornerRadius: 20)
                                    .frame(width:125, height:35)
                                    .foregroundColor(Color("appColor"))
                                Text("List a Rental")
                                    .foregroundColor(.white)
                                    .font(.custom("Jost-Regular", size: 20))
                        }
                    }
                }
                HStack{
                    Image(systemName: "list.bullet.circle.fill")
                        .resizable()
                        .foregroundColor(Color.accentColor)
                        .frame(width:30, height:30)
                    Spacer()
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "magnifyingglass.circle.fill")
                            .resizable()
                            .foregroundColor(Color.accentColor)
                            .frame(width:30, height:30)
                    })
                    TextField("Search for a dream car...", text: $userPreferences)
                        .frame(width:200, height:30)
                        .font(.custom("Jost-Regular", size: 18))
                    }
                ScrollView(){
                    Divider()
                        carListingLink(showSignInView: $showSignInView, imageName: "carExample", text: "2019 Honda Civic HB")
                        carListingLink(showSignInView: $showSignInView, imageName: "carExample2", text: "1995 Acura NSX-T Coupe")
                    

                }

        bottomNavigationBar(showSignInView: $showSignInView)
            }.frame(width:375)
        }
    }
}
#Preview {
    rentView(showSignInView: .constant(false), userPreferences: "")
}
