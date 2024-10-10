import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseAnalytics
import Combine
struct ContentView: View {
    
    @Binding var showSignInView: Bool
    @StateObject var viewModel = SignInEmailViewModel()
        
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                    .navigationBarBackButtonHidden(true)
                topNavigationBar()
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
                                imageBox(imageName: "carQuestLogo")
                                Text("")
                                    .font(Font.custom("Jost-Regular", size:17))
                                    .frame(maxWidth:200, maxHeight:15)
                                    .offset(x:-25)
                            }
                            VStack{
                                imageBox(imageName: "carExample")
                                Text("Recently viewed")
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
                RoundedRectangle(cornerRadius: 70)
                    .frame(width:345, height:1)
               bottomNavigationBar(showSignInView: $showSignInView)
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

struct bottomNavigationBar: View {
    @Binding var showSignInView: Bool
    var body: some View {
        HStack{
            Image("gavel")
                .resizable()
                .frame(width: 60, height:60)
            NavigationLink(destination: rentView(showSignInView: $showSignInView).navigationBarBackButtonHidden(true)) {
                Image("rent")
                    .resizable()
                    .frame(width: 55, height:55)
            }
            NavigationLink(destination: ContentView(showSignInView: $showSignInView).navigationBarBackButtonHidden(true)        .navigationBarTitleDisplayMode(.inline)
) {
                Image("home")
                    .resizable()
                    .frame(width: 55, height:55)
            }
            Image("buy")
                .resizable()
                .frame(width: 60, height:60)
            NavigationLink(destination: ProfileView(showSignInView: $showSignInView).navigationBarBackButtonHidden(true)) {
                Image("profileIcon")
                    .resizable()
                    .frame(width: 55, height:55)
            }
        }
    }
}
