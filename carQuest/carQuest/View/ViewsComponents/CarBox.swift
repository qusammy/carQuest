import SwiftUI
import SDWebImageSwiftUI
import FirebaseAuth
import FirebaseCore

struct imageBox: View {
    var imageName: URL?
    var carYear: String?
    var carMake: String?
    var carModel: String?
    var carType: String?
    var width: CGFloat
    var height: CGFloat
    var userID: String?
    var textSize: CGFloat?
    var body: some View {
        VStack{
            WebImage(url: imageName ?? URL(string: "4.png"))
                .resizable()
                .frame(width: width, height: height)
                .scaledToFill()
                .clipped()
            if carYear != nil && carModel != nil && carMake != nil && carType != nil {
                Text("\(carYear!) \(carMake!) \(carModel!) \(carType!)")
                    .font(.custom("Jost-Regular", size: textSize ?? 20))
                    .foregroundColor(Color.foreground)
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)
                    
            }
        }
    }
}

struct topNavigationBar: View {
    @Binding var showSignInView: Bool
    @ObservedObject var vm = UserProfileViewModel()
    
    @State var showNewMessageScreen = false
    
    @State var shouldNavigateToChatView = false


    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack{
            HStack{
                Text("CARQUEST")
                    .font(Font.custom("ZingRustDemo-Base", size:45))
                    .foregroundColor(Color.foreground)
                Spacer()
                NavigationLink("", isActive: $shouldNavigateToChatView){
                    ChatView(carUser: self.carUser)
                }
                Button(action: {
                    showNewMessageScreen.toggle()
                }, label: {
                    Image(systemName: "envelope.fill")
                        .resizable()
                        .frame(width:40, height:30)
                        .foregroundColor(Color.foreground)
                })
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
        }.fullScreenCover(isPresented: $showNewMessageScreen){
                        CreateNewMessage(didSelectNewUser: { user
                            in
                            print(user?.email ?? "")
                            self.shouldNavigateToChatView.toggle()
                            self.carUser = user
                        })
                    }
       .padding()
    }
    @State var carUser: CarQuestUser?
}

struct carListingLink: View {
    @Binding var showSignInView: Bool
    var imageName: String
    var text: String
    var body: some View {
        VStack{
            NavigationLink(destination: listingView(showSignInView: $showSignInView)) {
            VStack{
                imageBox(carYear: "", carMake: "", carModel: "", width: 100, height: 100, textSize: 10)
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
        HStack{
            Text(headerText)
                .font(Font.custom("ZingRustDemo-Base", size:30))
            Spacer()
        }
    }
}

struct previewListing: View {
    var carYear: String
    var make: String
    var model: String
    var carDescription: String
    var typeOfCar: String
    var date: Date
    var listingPrice: String
    var listedPhotos: [UIImage]?
    @State var isLiked: Bool
    
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
                        ForEach(listedPhotos!, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .clipped()
                                .frame(width:300, height:300)
                        }
                    }
                }
                VStack{
                    HStack{
                        Text("\(carYear) \(make) \(model) \(typeOfCar)")
                            .font(.custom("Jost-Regular", size: 25))
                            .frame(maxWidth: 375, alignment: .leading)
                            .foregroundColor(Color.foreground)
                        Spacer()
                        Button(action: {
                            isLiked.toggle()
                        }, label: {
                            ZStack{
                                Image(systemName: isLiked ? "heart.fill" : "heart")
                                    .resizable()
                                    .foregroundColor(.foreground)
                                    .frame(width:40, height:35)
                            }
                        })
                    }
                    Divider()
                    HStack{
                        WebImage(url: URL(string: vm.carUser?.profileImageURL ?? "profileIcon.png"))
                            .resizable()
                            .scaledToFill()
                            .frame(width:55, height:55)
                            .clipShape(Circle())
                        Text(vm.carUser?.display_name ?? "$username")
                            .font(.custom("Jost-Regular", size: 20))
                            .foregroundColor(.black)
                        Spacer()
                        Button(action: {
                            //brings up message view
                        }, label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 160, height: 35)
                                    .foregroundColor(Color("appColor"))
                                Text("Send a Message")
                                    .font(.custom("Jost-Regular", size:20))
                                    .foregroundColor(.white)
                            }
                        })
                    }
                    Text("\(carDescription)")
                        .font(.custom("Jost-Regular", size: 20))
                        .foregroundColor(Color(.init(white:0.65, alpha:1)))
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                    Divider()
                    HStack{
                        Text("Price per day: $\(listingPrice)")
                            .font(.custom("Jost-Regular", size: 22))
                            .foregroundColor(.black)
                        Button(action: {
                            //brings up booking view
                        }, label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 80, height: 35)
                                    .foregroundColor(.accentColor)
                                Text("Book")
                                    .font(.custom("Jost-Regular", size:20))
                                    .foregroundColor(.white)
                            }
                        })
                    }
                    Text("Listed \(date)")
                        .font(.custom("Jost-Regular", size: 20))
                        .foregroundColor(.gray)
                        .frame(maxWidth: 375, alignment: .leading)
                }
            }
        }.padding()
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

struct backButton: View {

    var body: some View {
        HStack{
            Image(systemName: "chevron.backward")
                .resizable()
                .frame(width:10, height:20)
                .foregroundColor(Color.accentColor)
            Text("Back")
                .font(Font.custom("Jost-Regular", size: 20))
                .foregroundColor(Color.accentColor)
        }
    }
}

struct StarsView: View {
    @Binding var rating: Int
    let highestRating = 5
    let unselected = Image(systemName: "star")
    let selected = Image(systemName: "star.fill")
    let font: Font = .largeTitle
    let fillColor: Color = .yellow
    let unfillColor: Color = .foreground
    var body: some View {
        HStack {
            ForEach(1...highestRating, id: \.self) { number in
                showStar(for: number)
                    .foregroundStyle(number <= rating ? fillColor : unfillColor)
                    .onTapGesture {
                        rating = number
                    }
            }
            
        }
    }
    
    func showStar(for number: Int) -> Image {
        if number > rating {
            return unselected
        }else {
            return selected
        }
    }
}
struct ReviewPod: View {
    var userImage: URL?
    var width: CGFloat?
    var height: CGFloat?
    var textSize: CGFloat?
    var userName: String?
    var title: String?
    var textBody: String?
    @State var rating: Double
    var body: some View {
        VStack{
            HStack{
                WebImage(url: userImage ?? URL(string: "profileIcon.png"))
                    .resizable()
                    .frame(width: width, height: height)
                    .scaledToFill()
                    .clipped()
                Text(userName ?? "")
                    .font(.custom("Jost-Regular", size: textSize ?? 20))
                    .foregroundColor(Color.foreground)
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)
                RatingView(rating: $rating, width: 15, height: 15)
                Spacer()
            }
            HStack {
                Text(title ?? "")
                    .frame(alignment: .leading)
                    .font(.custom("Jost-Regular", size: textSize ?? 20))
                    .foregroundColor(Color.foreground)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                Spacer()
            }
            HStack {
                Text(textBody ?? "")
                    .frame(alignment: .leading)
                    .font(.custom("Jost-Regular", size: textSize ?? 20))
                    .foregroundColor(Color.foreground)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                Spacer()
            }
        }
    }
}

struct RatingView: View {
    @Binding var rating: Double
    @State var width: CGFloat?
    @State var height: CGFloat?

    var body: some View {
        if rating > 0.0 {
            let stars = HStack(spacing: 0) {
                ForEach(0..<5, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width: width ?? 50, height: height ?? 50)
                }
            }
            
            stars.overlay(
                GeometryReader { g in
                    let width = rating / CGFloat(5) * g.size.width
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .frame(width: width)
                            .foregroundColor(.accentColor)
                    }
                }
                    .mask(stars)
            )
            .foregroundColor(.background)
            .onDisappear {
                rating = 0.0
            }
            
        } else {
            Text("")
        }
    }
}
