import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseAnalytics
import Combine
struct HomeView: View {
    
    static var isAlreadyLaunchedOnce = false // Used to avoid 2 FIRApp configure
    @Binding var showSignInView: Bool
    
    @StateObject private var viewModel = SignInEmailViewModel()
    @StateObject var viewModel2 = ListingViewModel()

    var body: some View {
        
        NavigationView {
            VStack {
                Spacer()
                    .navigationBarBackButtonHidden(true)
                ScrollView(showsIndicators: false){
                    VStack{
                        HStack {
                            if viewModel.displayName == "" {
                                Text("Welcome, $displayname!")
                                    .font(Font.custom("Jost", size:30))
                                    .foregroundColor(Color("Foreground"))
                            }else {
                                Text("Welcome, \(viewModel.displayName)!")
                                    .font(Font.custom("Jost", size:30))
                                    .foregroundColor(Color("Foreground"))
                            }
                        }
                        Divider()
                        HStack{
                            Text("Recently viewed")
                                .font(Font.custom("Jost-Regular", size:20))
                            Spacer()
                            Text("See all")
                                .font(Font.custom("Jost-Regular", size:15))
                                .underline()
                        }.padding(.horizontal, 10.0)
                        HStack{
                           
                        }
                        HStack{
                            carListingLink(showSignInView: $showSignInView, imageName: "carExample", text: "2019 Honda Civic Hatchback")
                            Spacer()
                            carListingLink(showSignInView: $showSignInView, imageName: "carExample", text: "2019 Honda Civic Hatchback")
                        }
                        Divider()
                        HStack{
                            Text("Liked vehicles")
                                .font(Font.custom("Jost-Regular", size:20))
                            Spacer()
                            Text("See all")
                                .font(Font.custom("Jost-Regular", size:15))
                                .underline()
                        }.padding(.horizontal, 10.0)
                        HStack{
                            carListingLink(showSignInView: $showSignInView, imageName: "carExample", text: "2019 Honda Civic Hatchback")
                            Spacer()
                            carListingLink(showSignInView: $showSignInView, imageName: "carExample", text: "2019 Honda Civic Hatchback")
                        }
                    }.padding()
                }
            }
        }.onAppear{
            if FirebaseApp.app() == nil {
                FirebaseApp.configure()
            }
        }.navigationViewStyle(StackNavigationViewStyle())
            .task {
                viewModel.getDisplayName()
            }
    }
}
#Preview {
    HomeView(showSignInView: .constant(false))
}

