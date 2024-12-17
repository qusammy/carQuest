//
//  listingView.swift
//  carQuest
//
//  Created by Maddy Quinn on 9/24/24.
//
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct listingView: View {
    @State private var isLiked: Bool = false
    @State private var likeTapped: Bool = false
    @Binding var showSignInView: Bool
    @StateObject var viewModel = ListingViewModel()
    @StateObject var userViewModel = UserInfoViewModel()


    var body: some View {
        VStack{
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
                            //brings up booking view
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
                        }, label: {
                            ZStack{
                                Image(systemName: isLiked ? "heart.fill" : "heart")
                                    .resizable()
                                    .foregroundColor(.black)
                                    .frame(width:40, height:35)
                            }
                        }).offset(x:40)
                    }
                        HStack {
                            Text("Year: \(viewModel.carYear)")
                                    .font(.custom("Jost-Regular", size: 25))
                                    .frame(maxWidth: 375, alignment: .leading)
                                    .foregroundColor(.black)
                            Text("Make: \(viewModel.carMake)")
                                    .font(.custom("Jost-Regular", size: 25))
                                    .frame(maxWidth: 375, alignment: .leading)
                                    .foregroundColor(.black)
                            Text("Model: \(viewModel.carModel)")
                                    .font(.custom("Jost-Regular", size: 25))
                                    .frame(maxWidth: 375, alignment: .leading)
                                    .foregroundColor(.black)
                            Text("Type: \(viewModel.carType)")
                                    .font(.custom("Jost-Regular", size: 25))
                                    .frame(maxWidth: 375, alignment: .leading)
                                    .foregroundColor(.black)
                        }
                        HStack{
                            Image("\(userViewModel.photoURL)")
                                .resizable()
                                .frame(width:55, height:55)
                            Text("\(userViewModel.displayName)")
                                .font(.custom("Jost-Regular", size: 20))
                                .foregroundColor(.black)
                                .frame(maxWidth: 375, alignment: .leading)
                        }
                    Text("Description: \(viewModel.carDescription)")
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
        }.task {
            do {
                try await viewModel.getListingInfo()
            }catch {
                print("Getting Listing Data Failed")
            }
        }
    }
}
#Preview {
    listingView(showSignInView: .constant(false))
}
