//
//  CarBox.swift
//  carQuest
//
//  Created by beraoud_981215 on 9/13/24.
//
import SwiftUI

struct imageBox: View {
    var imageName: String
    var body: some View {
        VStack{
            Image(imageName)
                .resizable()
                .frame(width:200, height:200)
                .clipped()
        }
    }
}

struct topNavigationBar: View {
    var body: some View {
        VStack{
            HStack{
                Text("CARQUEST")
                    .font(Font.custom("ZingRustDemo-Base", size:50))
                    .foregroundColor(Color("Foreground"))
                Spacer()
                Image(systemName: "bell.fill")
                    .resizable()
                    .frame(width:30, height:30)
                    .foregroundColor(Color("Foreground"))
            }
            RoundedRectangle(cornerRadius: 70)
                .frame(width:345, height:1)
        }
    }
}
struct bottomNavigationBar: View {
    @Binding var showSignInView: Bool
    var body: some View {
        VStack{
            RoundedRectangle(cornerRadius: 70)
                .frame(width:345, height:1)
            HStack{
                Image("gavel")
                    .resizable()
                    .frame(width: 60, height:60)
                NavigationLink(destination: rentView(showSignInView: $showSignInView).navigationBarBackButtonHidden(true)) {
                    Image("rent")
                        .resizable()
                        .frame(width: 55, height:55)
                }
                NavigationLink(destination: ContentView(showSignInView: $showSignInView).navigationBarBackButtonHidden(true)        .navigationBarTitleDisplayMode(.inline)
                ) {
                    Image("home")
                        .resizable()
                        .frame(width: 55, height:55)
                }
                Image("buy")
                    .resizable()
                    .frame(width: 60, height:60)
                NavigationLink(destination: ProfileView(showSignInView: $showSignInView).navigationBarBackButtonHidden(true)) {
                    Image("profileIcon")
                        .resizable()
                        .frame(width: 55, height:55)
                }
            }
        }
    }
}

struct carListingLink: View {
    @Binding var showSignInView: Bool
    var body: some View {
        VStack{
        NavigationLink(destination: listingView(showSignInView: $showSignInView).navigationBarBackButtonHidden(true)) {
            VStack{
                imageBox(imageName: "carQuestLogo")
                Text("")
                .font(.custom("Jost-Regular", size:17))
                .frame(maxWidth:370, maxHeight:15)
                .multilineTextAlignment(.leading)
                    }
                }
                
            }
    }
}

struct headline: View {
    var headerText: String
    var body: some View {
        Text(headerText)
            .font(Font.custom("ZingRustDemo-Base", size:30))
            .frame(maxWidth: 375, alignment: .leading)
    }
}

struct previewListing: View {
    @Binding var carYear: String
    @Binding var make: String
    @Binding var model: String
    @Binding var description: String
    @Binding var typeOfCar: String
    @Binding var date: Date
    @Binding var listedPhoto1: Image?
    @Binding var listedPhoto2: Image?
    var body: some View{
        VStack{
            RoundedRectangle(cornerRadius: 70)
                .frame(width:345, height:2)
                .padding(.top, 5.0)
            Text("Preview listing")
                .font(.custom("Jost-Regular", size: 30))
                .foregroundColor(.black)
            ScrollView{
                ScrollView(.horizontal, showsIndicators: false)
                {
                    HStack{
                        listedPhoto1?
                            .resizable()
                            .clipped()
                            .frame(width:300, height:300)
                        listedPhoto2?
                            .resizable()
                            .clipped()
                            .frame(width:300, height:300)
                    }
                }
                
                Text("\(carYear) \(make) \(model) \(typeOfCar)")
                    .font(.custom("Jost-Regular", size: 25))
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
                Text("\(description)")
                    .font(.custom("Jost-Regular", size: 20))
                    .foregroundColor(.black)
                    .frame(maxWidth: 375, alignment: .leading)
                    .multilineTextAlignment(.leading)
                Text("Listed \(date)")
                    .font(.custom("Jost-Regular", size: 20))
                    .foregroundColor(.gray)
                    .frame(maxWidth: 375, alignment: .leading)
            }
        }
    }
}

struct listingTextField: View {
    @Binding var carFactor: String
    @State var textFieldText: String
    var body: some View {
        TextField("\(textFieldText)", text: $carFactor)
            .foregroundColor(.black)
            .frame(width:375, height:50)
            .font(.custom("Jost-Regular", size: 20))
            .background(Color(hue: 1.0, saturation: 0.005, brightness: 0.927))
            .cornerRadius(10)
            .multilineTextAlignment(.leading)
    }
}
