//
//  AuctionView.swift
//  carQuest
//
//  Created by Maddy Quinn on 11/8/24.
//

import SwiftUI

struct AuctionView: View {
    @Binding var showSignInView: Bool
    var body: some View {
        VStack{
            topNavigationBar(showSignInView: $showSignInView)
            ScrollView(){
                VStack{
                    NavigationLink(destination: listingCreation(carType: "", location: "", carModel: "", carMake: "", carDescription:"", showSignInView: $showSignInView).navigationBarBackButtonHidden(true)){
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width:275, height:50)
                                .foregroundColor(Color("appColor"))
                            Text("List a car for auction")
                                .foregroundColor(.white)
                                .font(.custom("Jost-Regular", size: 30))
                        }
                    }
                    Divider()
                    HStack{
                        //carBox elements will go here. links to auction view in separate HStack lines! still being built
                        NavigationLink(destination: AuctionListingView(showSignInView: $showSignInView, bid: "").navigationBarBackButtonHidden(true)){
                            VStack{
                                Image("carQuestLogo")
                                    .resizable()
                                    .frame(width: 150, height: 150)
                                Text("Car for auction")
                                    .foregroundColor(.black)
                                    .font(Font.custom("Jost-Regular", size: 20))
                            }
                        }
                    }
                }
            }
            bottomNavigationBar(showSignInView: $showSignInView)
        }
    }
}

#Preview {
    AuctionView(showSignInView: .constant(false))
}
