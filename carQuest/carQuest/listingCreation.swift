//
//  listingCreation.swift
//  carQuest
//
//  Created by Maddy Quinn on 8/29/24.
//  Additions by James Hollander

import SwiftUI

struct listingCreation: View {
    var body: some View {
        VStack{
            Image(systemName: "x.circle.fill")
                .resizable()
                .frame(width:40, height:40)
                .foregroundColor(Color(hue: 1.0, saturation: 0.005, brightness: 0.927))
            Text("Create listing")
                .font(Font.custom("Jost-Regular", size:40))
            
            
        }
    }
}

#Preview {
    listingCreation()
}
