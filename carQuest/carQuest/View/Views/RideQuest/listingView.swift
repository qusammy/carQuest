//
//  listingView.swift
//  carQuest
//
//  Created by Maddy Quinn on 9/24/24.
//
import SwiftUI
import Firebase
import FirebaseFirestore
struct listingView: View {
    let db = Firestore.firestore()
    @State private var isLiked: Bool = false
    @State private var likeTapped: Bool = false
    var body: some View {
        VStack{
            Button(action: {
                
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
            }).offset(x:-140)
            ScrollView{
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        Image("carQuestLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                        Image("carQuestLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                    }
                }
                VStack{
                    HStack{
                        Button(action: {
                        //brings up message view
                        }, label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 80, height: 35)
                                    .foregroundColor(.black)
                                Text("Book")
                                    .font(.custom("Jost-Regular", size:20))
                                    .foregroundColor(.white)
                            }
                        }).offset(x:-40)
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
                        Button(action: {
                            isLiked.toggle()
                            likeTapped.toggle()
                        }, label: {
                            ZStack{
                                Image(systemName: isLiked ? "heart.fill" : "heart")
                                    .resizable()
                                    .foregroundColor(.black)
                                    .frame(width:40, height:35)
                            }
                        }).offset(x:40)
                    }
                    if likeTapped == true {
                        Text("added to liked vehicles")
                            .font(.custom("Jost-Regular", size: 15))
                            .foregroundColor(.black)
                    }
                    Text("year make model type")
                        .font(.custom("Jost-Regular", size: 25))
                        .frame(maxWidth: 375, alignment: .leading)
                        .foregroundColor(.black)
                    HStack{
                        Image("profileIcon")
                            .resizable()
                            .frame(width:55, height:55)
                        Text("$username")
                            .font(.custom("Jost-Regular", size: 20))
                            .foregroundColor(.black)
                            .frame(maxWidth: 375, alignment: .leading)
                    }
                    Text("Description")
                        .font(.custom("Jost-Regular", size: 20))
                        .foregroundColor(.black)
                        .frame(maxWidth: 375, alignment: .leading)
                        .multilineTextAlignment(.leading)
                    Text("Listed date")
                        .font(.custom("Jost-Regular", size: 20))
                        .foregroundColor(.gray)
                        .frame(maxWidth: 375, alignment: .leading)
                }
            }
        }
    }
    func readListings(){
        db.collection("carListings").document().getDocument { (document, error) in
            if let document = document {
                let make = document.data()?["carMake"] as? String
                let type = document.data()?["carType"] as? Bool
            }
        }
    }
}
#Preview {
    listingView()
}
