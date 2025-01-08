//
//  RootView.swift
//  carQuest
//
//  Created by hollande_894789 on 9/11/24.
//
import SwiftUI

struct RootView: View {

    @State private var showSignInView: Bool = false

    
    var body: some View {
        ZStack {
            ContentView(showSignInView: $showSignInView)
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {

            HomeView(showSignInView: $showSignInView)
            
        }
    }
}

#Preview{
    RootView()
}
