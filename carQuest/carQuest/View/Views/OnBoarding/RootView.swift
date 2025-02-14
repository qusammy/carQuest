import SwiftUI

struct RootView: View {

    @State private var showSignInView: Bool = false

    
    var body: some View {
        ZStack {
            ContentView(showSignInView: $showSignInView, selection: 3)
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {

            SignInView(showSignInView: $showSignInView)
            
        }
    }
}

#Preview{
    RootView()
}
