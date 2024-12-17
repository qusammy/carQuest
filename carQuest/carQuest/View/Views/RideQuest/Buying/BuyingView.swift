//
//  BuyingView.swift
//  carQuest
//
//  Created by Maddy Quinn on 12/11/24.
//

import SwiftUI

struct BuyingView: View {
    @Binding var showSignInView: Bool
    var body: some View {
        VStack{
            topNavigationBar(showSignInView: $showSignInView)
            ScrollView{
                
            }
        }
    }
}

#Preview {
    BuyingView(showSignInView: .constant(false))
}
