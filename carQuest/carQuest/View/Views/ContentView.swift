// We Are in james branch
//  ContentView.swift
//  carQuest
//
//  Created by Maddy Quinn on 8/19/24.
//  Additions by James Hollander
// when navigation view, use .navigationViewStyle(StackNavigationViewStyle()) at the last bracket
import SwiftUI

struct ContentView: View {
    var body: some View{
        HomeView(showSignInView: .constant(false))
    }
}

#Preview {
    ContentView()
}
