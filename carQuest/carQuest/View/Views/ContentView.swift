import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseAnalytics
import Combine
struct ContentView: View {
    @Binding var showSignInView: Bool
    
    @State var selection: Int
    
    var body: some View {
        NavigationStack{
            VStack{
                topNavigationBar(showSignInView: $showSignInView)
                TabView(selection: $selection){
                    
                    AuctionView(showSignInView: $showSignInView, searchText: "")
                        .tabItem{
                            Image(systemName: "building.columns.fill")
                        }.tag(1)
                    
                    rentView(showSignInView: $showSignInView, searchText: "")
                        .tabItem{
                            Image(systemName: "key.horizontal.fill")
                        }.tag(2)
                    
                    HomeView(showSignInView: $showSignInView)
                        .tabItem{
                            Label("", systemImage: "house.fill")
                        }.tag(3)
                    
                    BuyingView(showSignInView: $showSignInView, searchText: "")
                        .tabItem{
                            Label("", systemImage: "dollarsign")
                        }.tag(4)
                    ProfileView(showSignInView: $showSignInView)
                        .tabItem{
                            Image(systemName: "person.circle.fill")
                        }.tag(5)
                }
            }
        }
    }
}
#Preview {
    ContentView(showSignInView: .constant(false), selection: 3)
}

