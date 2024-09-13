//
//  settingsView.swift
//  carQuest
//
//  Created by Maddy Quinn on 9/11/24.
//

import SwiftUI

struct settingsView: View {
    
    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    Text("Settings")
                        .font(.custom("Jost-Regular", size: 30))
                        .foregroundColor(.black)
                }
                List(){
                    Text("Push notifications")
                        .font(.custom("Jost-Regular", size: 20))
                        .foregroundColor(.black)
                    Text("App appearance")
                        .font(.custom("Jost-Regular", size: 20))
                        .foregroundColor(.black)
                    Text("Privacy")
                        .font(.custom("Jost-Regular", size: 20))
                        .foregroundColor(.black)
                    Text("About this app")
                        .font(.custom("Jost-Regular", size: 20))
                        .foregroundColor(.black)
                }.listStyle(.plain)
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
            }
        }
    }
}

#Preview {
    settingsView()
}

