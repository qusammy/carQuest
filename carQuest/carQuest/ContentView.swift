//
//  ContentView.swift
//  carQuest
//
//  Created by Maddy Quinn on 8/19/24.
//
// when navigation view, use .navigationViewStyle(StackNavigationViewStyle()) at the last bracket
import SwiftUI

struct ContentView: View {
    
    @State private var isHeartFilled: Bool = false
    
    var body: some View {

        VStack {
            HStack{
                Text("CARQUEST")
                    .font(Font.custom("ZingRustDemo-Base", size:50))
                Spacer()
                Image(systemName: "bell.fill")
                    .resizable()
                    .frame(width:30, height:30)
            } /*.offset(y: -540)*/
            RoundedRectangle(cornerRadius: 70)
                .frame(width:345, height:1)
//                .offset(y: -570)
            ScrollView{
                VStack{
                    Text("Welcome, name!")
                        .font(Font.custom("Jost-Regular", size:30))
                    HStack{
                        Text("Recently viewed")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(Font.custom("Jost-Regular", size:20))
                        Text("See all")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .font(Font.custom("Jost-Regular", size:15))
                            .underline()
                    }
                    HStack{
                        imageBox()
                        imageBox()
                        }
                    HStack{
                        imageBox()
                        imageBox()
                        }
                    RoundedRectangle(cornerRadius: 70)
                        .frame(width:345, height:1)
                    HStack{
                        Text("Saved for later")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(Font.custom("Jost-Regular", size:20))
                        Text("See all")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .font(Font.custom("Jost-Regular", size:15))
                            .underline()
                    }
                    HStack{
                        imageBox()
                        imageBox()
                    }
                }
            }.frame(width:350)
           
            RoundedRectangle(cornerRadius: 70)
                .frame(width:345, height:1)
                    HStack{
                        Image("gravelLightMode")
                            .resizable()
                            .frame(width: 70, height:70)
                        Image("rentLightMode")
                            .resizable()
                            .frame(width: 70, height:70)
                        Image("homeLightMode")
                            .resizable()
                            .frame(width: 60, height:60)
                        Image("buyLightMode")
                            .resizable()
                            .frame(width: 60, height:60)
                        Image("profileIcon")
                            .resizable()
                            .frame(width: 55, height:55)
                    }
                }/*.offset(x:0,y:280)*/
        .padding()
    }
    //structs
    func image (_ image: Image, show: Bool) -> some View {
            image
            .resizable()
            .tint(isHeartFilled ? .white : .black)
            .offset(x:65, y:-65)
            .frame(width:40, height:40)
    }
    
    
}

#Preview {
    ContentView()
}
struct imageBox: View
{
    private var _name = ""

    var body: some View {
        ZStack{
            FittedImage(imageName: _name, width: 180, height: 180)
            Image(systemName: "heart")
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width:40, height:35)
                    .offset(x:65, y:-65)
        }
        
    }
}

struct FittedImage: View
{
    var imageName: String
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        VStack {
            Image("carQuestLogo")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
        }
        .frame(width: width, height: height)
    }
}

//Unfitted image struct

//struct imageBox2: View {
//    var body: some View{
//        ZStack{
//            Image("carExample")
//                .resizable()
//                .scaledToFit()
//                .frame(width:180, height:180)
//            Image(systemName: "heart")
//                .resizable()
//                .foregroundColor(.white)
//                .frame(width:35, height:35)
//                .offset(x:65, y:-65)
//        }
//        Text("2019 Civic LX white 4 door")
//            .font(Font.custom("Jost-Regular", size: 15))
//            .lineLimit(1)
//    }
//}
