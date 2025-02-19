import SwiftUI

struct NotificationsView: View {
    @State var notificationAlert: Bool = true
    var body: some View {
        VStack{
            HStack{
                Text("Notifications")
                    .font(Font.custom("ZingRustDemo-Base", size: 40))
                    .foregroundColor(Color.foreground)
                Spacer()
            }
            ScrollView{
                VStack{
                    ForEach(0..<10) { num in
                        HStack{
                            Text("Listing")
                                .font(Font.custom("Jost-Regular", size: 25))
                                .foregroundColor(Color.foreground)
                            Spacer()
                            Text("$username sent you a message about your listing.")
                                .foregroundColor(Color(.init(white:0.65, alpha:1)))
                                .multilineTextAlignment(.leading)
                            Divider()
                        }
                    }
                }
            }
        }.padding()
    }
}

#Preview {
    NotificationsView()
}
