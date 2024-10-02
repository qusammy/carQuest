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
