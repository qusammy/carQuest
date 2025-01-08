import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseAnalytics
import Combine
struct ContentView: View {
    @Binding var showSignInView: Bool
    
    @State private var selection = 3
    
    var body: some View {
        NavigationStack{
            VStack{
                topNavigationBar(showSignInView: $showSignInView)
                TabView(selection: $selection){
                    
                    AuctionView(showSignInView: $showSignInView)
                        .tabItem{
                            Label("", systemImage:("dollarsign.circle.fill"))
                        }.tag(1)
                    
                    rentView(showSignInView: $showSignInView)
                        .tabItem{
                            Image(systemName: "key.horizontal.fill")
                        }.tag(2)
                    
                    HomeView(showSignInView: $showSignInView)
                        .tabItem{
                            Label("", systemImage: "house.fill")
                        }.tag(3)
                    
                    BuyingView(showSignInView: $showSignInView)
                        .tabItem{
                            Label("", systemImage: "dollarsign")
                        }.tag(4)
                    ProfileView(showSignInView: $showSignInView)
                        .tabItem{
                            Image(systemName: "person.circle.fill")
                        }
                }
            }
        }
    }
}
#Preview {
    ContentView(showSignInView: .constant(false))
}

