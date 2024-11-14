//
//  AuctionListingView.swift
//  carQuest
//
//  Created by Maddy Quinn on 11/8/24.
//

import SwiftUI

struct AuctionListingView: View {
    @Binding var showSignInView: Bool
    @State var bid: String
    @State var isLiked: Bool = false
    var body: some View {
        VStack{
            ZStack{
                NavigationLink(destination: AuctionView(showSignInView: $showSignInView).navigationBarBackButtonHidden(true)) {
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
            }.offset(x:-140)
            ScrollView{
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        Image("carQuestLogo")
                            .resizable()
                            .frame(width:300, height:300)
                        Image("carQuestLogo")
                            .resizable()
                            .frame(width:300, height:300)
                    }
                }
                HStack{
                    Text("year make model type")
                        .font(.custom("Jost-Regular", size: 25))
                        .frame(maxWidth: 375, alignment: .leading)
                        .foregroundColor(.black)
                    Button(action: {
                        isLiked.toggle()
                    }, label: {
                        ZStack{
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .resizable()
                                .foregroundColor(.black)
                                .frame(width:40, height:35)
                        }
                    })
                }
                Divider()
                HStack{
                    Image("profileIcon")
                        .resizable()
                        .frame(width:55, height:55)
                    Text("$username")
                        .font(.custom("Jost-Regular", size:20))
                        .foregroundColor(.black)
                    Spacer()
                    Button(action: {
                        //brings up message view
                    }, label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 15)
                                .frame(width: 160, height: 35)
                                .foregroundColor(Color("appColor"))
                            Text("Send a Message")
                                .font(.custom("Jost-Regular", size:20))
                                .foregroundColor(.white)
                        }
                    })
                }
                Text("This is an example of the description of the auction. The text will be leading.")
                    .font(.custom("Jost-Regular", size: 20))
                    .foregroundColor(Color(.init(white:0.65, alpha:1)))
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                Divider()
                HStack{
                    Text("x bids")
                        .font(.custom("Jost-Regular", size: 22))
                        .foregroundColor(.black)
                        .underline()
                    Text("Highest bid:")
                        .font(.custom("Jost-Regular", size: 20))
                        .foregroundColor(.black)
                    Text("$0000.00")
                        .font(.custom("Jost-Regular", size: 22))
                        .foregroundColor(.black)
                }
                HStack{
                    TextField("0000.00", text: $bid)
                        .keyboardType(.numberPad)
                        
                    Button(action: {
                        //brings up message view
                    }, label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 15)
                                .frame(width: 125, height: 45)
                                .foregroundColor(Color("appColor"))
                            Text("Place a bid")
                                .font(.custom("Jost-Regular", size:20))
                                .foregroundColor(.white)
                        }
                    })
                }
            }
        }.frame(maxWidth:375)
    }
}

#Preview {
    AuctionListingView(showSignInView: .constant(false), bid: "")
}
