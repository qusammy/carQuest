//  Created by Maddy Quinn on 9/30/24.
//
import SwiftUI
struct rentView: View {
    var body: some View {
        NavigationView{
            VStack{
                RoundedRectangle(cornerRadius: 70)
                    .frame(width:345, height:1)
                HStack{
                    Image("gavel")
                        .resizable()
                        .frame(width: 60, height:60)
                    Image("home")
                        .resizable()
                        .frame(width: 60, height:60)
                    Image("buy")
                        .resizable()
                        .frame(width: 60, height:60)
                  
                }
            }
        }
    }
}
#Preview {
    rentView()
}
