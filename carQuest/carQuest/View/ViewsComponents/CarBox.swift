//
//  CarBox.swift
//  carQuest
//
//  Created by beraoud_981215 on 9/13/24.
//
import SwiftUI
import SDWebImageSwiftUI
import FirebaseAuth


struct imageBox: View {
    var imageName: URL?
    var carYear: String?
    var carMake: String?
    var carModel: String?
    var carType: String?
    var width: CGFloat
    var height: CGFloat
    var body: some View {
        VStack{
            WebImage(url: imageName ?? URL(string: "4.png"))
                .resizable()
                .frame(width: width, height: height)
                .scaledToFill()
                .clipped()
            if carYear != nil && carModel != nil && carMake != nil && carType != nil {
                Text("\(carYear!) \(carMake!) \(carModel!) \(carType!)")
                    .font(.custom("Jost-Regular", size:20))
                    .foregroundColor(Color.foreground)
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)
            }
        }
    }
}

struct topNavigationBar: View {
    @Binding var showSignInView: Bool
    var body: some View {
        VStack{
            HStack{
                Text("CARQUEST")
                    .font(Font.custom("ZingRustDemo-Base", size:45))
                    .foregroundColor(Color.foreground)
                Spacer()
                NavigationLink(destination: MainChatView(showSignInView: $showSignInView).navigationBarBackButtonHidden(true)) {
                    Image(systemName: "envelope.fill")
                        .resizable()
                        .frame(width:40, height:30)
                        .foregroundColor(Color.foreground)
                }
                NavigationLink(destination: NotificationsView()) {
                    Image(systemName: "bell.fill")
                        .resizable()
                        .frame(width:30, height:30)
                        .foregroundColor(Color.foreground)
                }
                
            }
            if Auth.auth().currentUser?.isEmailVerified == false {
                Text("Please verify your email address.")
                    .font(.custom("Jost-Regular", size: 15))
                    .foregroundColor(.blue)
                    .multilineTextAlignment(.leading)
            }
        }
        .frame(width:375)
        
    }
}
struct bottomNavigationBar: View {
    @Binding var showSignInView: Bool
    @ObservedObject var vm = UserProfileViewModel()
    var body: some View {
        VStack{
            RoundedRectangle(cornerRadius: 70)
                .frame(width:345, height:1)
            HStack{
                NavigationLink(destination: AuctionView(showSignInView: $showSignInView).navigationBarBackButtonHidden(true)){
                    Image("gavel")
                        .resizable()
                        .frame(width: 62, height:62)
                }
                Spacer()
                NavigationLink(destination: rentView(showSignInView: $showSignInView).navigationBarBackButtonHidden(true)) {
                    Image("rent")
                        .resizable()
                        .frame(width: 57, height:57)
                }
                Spacer()
                NavigationLink(destination: HomeView(showSignInView: $showSignInView).navigationBarBackButtonHidden(true)        .navigationBarTitleDisplayMode(.inline)
                ) {
                    Image("home")
                        .resizable()
                        .frame(width: 57, height:57)
                }
                Spacer()
                NavigationLink(destination: BuyingView(showSignInView: $showSignInView).navigationBarBackButtonHidden(true)        .navigationBarTitleDisplayMode(.inline)
                ) {
                    Image("buy")
                        .resizable()
                        .frame(width: 62, height:62)
                }
                Spacer()
                NavigationLink(destination: ProfileView(showSignInView: $showSignInView).navigationBarBackButtonHidden(true)) {
                    if vm.carUser?.profileImageURL == nil {
                        Image("profileIcon")
                            .resizable()
                            .scaledToFill()
                            .frame(width:47, height:47)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                    } else {
                        WebImage(url: URL(string: vm.carUser?.profileImageURL ?? "profileIcon"))
                            .resizable()
                            .frame(width: 47, height:47)
                            .scaledToFill()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                    }
                }
            }
        }
        .background(Color.background)
        .padding()
    }
}

struct carListingLink: View {
    @Binding var showSignInView: Bool
    var imageName: String
    var text: String
    var body: some View {
        VStack{
            NavigationLink(destination: listingView(showSignInView: $showSignInView)) {
            VStack{
                imageBox(carYear: "", carMake: "", carModel: "", width: 100, height: 100)
                Text("")
                .font(.custom("Jost-Regular", size:17))
                .foregroundColor(Color.foreground)
                .lineLimit(1)
                .multilineTextAlignment(.leading)
                    }
                }
                
            }
    }
}

struct headline: View {
    var headerText: String
    var body: some View {
        Text(headerText)
            .font(Font.custom("ZingRustDemo-Base", size:30))
            .frame(maxWidth: 375, alignment: .leading)
    }
}

struct previewListing: View {
    @Binding var carYear: String
    @Binding var make: String
    @Binding var model: String
    @Binding var description: String
    @Binding var typeOfCar: String
    @Binding var date: Date
    @Binding var listedPhoto1: UIImage?
    
    @ObservedObject var vm = UserProfileViewModel()
    var body: some View{
        VStack{
            RoundedRectangle(cornerRadius: 70)
                .frame(width:345, height:2)
                .padding(.top, 5.0)
            Text("Preview listing")
                .font(.custom("Jost-Regular", size: 30))
                .foregroundColor(.black)
            ScrollView{
                ScrollView(.horizontal, showsIndicators: false)
                {
                    HStack{
                        Image(uiImage: listedPhoto1!)
                            .resizable()
                            .clipped()
                            .frame(width: 300, height: 300)
                    }
                }
                
                Text("\(carYear) \(make) \(model) \(typeOfCar)")
                    .font(.custom("Jost-Regular", size: 25))
                    .foregroundColor(.black)
                HStack{
                    WebImage(url: URL(string: vm.carUser?.profileImageURL ?? "profileIcon.png"))
                        .resizable()
                        .scaledToFill()
                        .frame(width:55, height:55)
                        .clipShape(Circle())
                    Text(vm.carUser?.display_name ?? "$username")
                        .font(.custom("Jost-Regular", size: 20))
                        .foregroundColor(.black)
                        .frame(maxWidth: 375, alignment: .leading)
                }
                Text("\(description)")
                    .font(.custom("Jost-Regular", size: 20))
                    .foregroundColor(.black)
                    .frame(maxWidth: 375, alignment: .leading)
                    .multilineTextAlignment(.leading)
                Text("Listed \(date)")
                    .font(.custom("Jost-Regular", size: 20))
                    .foregroundColor(.gray)
                    .frame(maxWidth: 375, alignment: .leading)
            }
        }
    }
}

struct listingTextField: View {
    @Binding var carFactor: String
    @State var textFieldText: String
    var body: some View {
        TextField("\(textFieldText)", text: $carFactor)
            .foregroundColor(.black)
            .frame(width:375, height:50)
            .font(.custom("Jost-Regular", size: 20))
            .background(Color(hue: 1.0, saturation: 0.005, brightness: 0.927))
            .cornerRadius(10)
            .multilineTextAlignment(.leading)
    }
}

//struct recentMessageTextBox: View{
//    @State var carUser: CarQuestUser?
//    @ObservedObject var vm = CreateNewMessageViewModel()
//    var body: some View {
//        NavigationLink(destination: ChatView(carUser: carUser)){
//            VStack(alignment: .leading){
//                HStack{
//                    Image("profileIcon")
//                        .resizable()
//                        .frame(width:60, height:60)
//                    VStack{
//                        Text("recentMessage.display_name")
//                            .font(Font.custom("Jost-Regular", size:25))
//                            .foregroundColor(.black)
//                        Text("recent message")
//                            .font(Font.custom("Jost-Regular", size:17))
//                            .foregroundColor(Color(red: 0.723, green: 0.717, blue: 0.726))
//                    }
//                }
//                Divider()
//            }
//        }
//    }
//}
