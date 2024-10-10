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
