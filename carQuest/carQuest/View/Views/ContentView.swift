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
                                        //                                imageBox(imageName: UIImage(imageLiteralResourceName: "carquestLogo"), carYear: "", carMake: "", carModel: "")
                                                                            }
                                    }
                                    
                                }
                                VStack{
                                    //                            imageBox(imageName: UIImage(imageLiteralResourceName: "carquestLogo"), carYear: "2019", carMake: "Honda", carModel: "Civic")
                                }
                            }
                            HStack{
                                //                            imageBox(imageName: UIImage(imageLiteralResourceName: "carquestLogo"), carYear: "", carMake: "", carModel: "")
                                //                            imageBox(imageName: UIImage(imageLiteralResourceName: "carquestLogo"), carYear: "", carMake: "", carModel: "")
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

