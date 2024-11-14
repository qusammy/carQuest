import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseAnalytics
import Combine
struct ContentView: View {
    
    static var isAlreadyLaunchedOnce = false // Used to avoid 2 FIRApp configure
    @Binding var showSignInView: Bool
    
    @StateObject private var viewModel = SignInEmailViewModel()
        
    var body: some View {
      
        NavigationView {
            VStack {
                Spacer()
                    .navigationBarBackButtonHidden(true)
                topNavigationBar(showSignInView: $showSignInView)
                ScrollView{
                    VStack{
                        HStack {
                            if viewModel.displayName == "" {
                                Text("Welcome User!")
                                    .font(Font.custom("Jost", size:30))
                                    .foregroundColor(Color("Foreground"))
                            }else {
                                Text("Welcome \(viewModel.displayName)!")
                                    .font(Font.custom("Jost", size:30))
                                    .foregroundColor(Color("Foreground"))
                            }
                        }
                        HStack{
                            Text("Recently viewed")
                                .font(Font.custom("Jost-Regular", size:20))
                            Spacer()
                            Text("See all")
                                .font(Font.custom("Jost-Regular", size:15))
                                .underline()
                    }
                    HStack{
                        VStack{
                        NavigationLink(destination: listingView(showSignInView: $showSignInView).navigationBarBackButtonHidden(true)) {
                            VStack{
                                imageBox(imageName: "carQuestLogo")
                                Text("")
                                .font(.custom("Jost-Regular", size:17))
                                .frame(maxWidth:370, maxHeight:15)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.black)
                                    }
                                }
                                
                            }
                        VStack{
                            imageBox(imageName: "carExample")
                            Text("2019 Honda Civic")
                                .font(Font.custom("Jost-Regular", size:17))
                                .frame(maxWidth:200, maxHeight:15)
                                .offset(x:-40)
                            }
                        }
                        HStack{
                            imageBox(imageName: "carQuestLogo")
                            imageBox(imageName: "carQuestLogo")
                        }
                        RoundedRectangle(cornerRadius: 70)
                            .frame(width:345, height:1)
                        HStack{
                            Text("Liked vehicles")
                                .font(Font.custom("Jost-Regular", size:20))
                            Spacer()
                            Text("See all")
                                .font(Font.custom("Jost-Regular", size:15))
                                .underline()
                        }
                        HStack{
                        }
                    }.frame(width:375)
                }
               bottomNavigationBar(showSignInView: $showSignInView)
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
    ContentView(showSignInView: .constant(false))
}

