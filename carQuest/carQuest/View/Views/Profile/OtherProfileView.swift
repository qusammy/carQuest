//
//  OtherProfileView.swift
//  carQuest
//
//  Created by Maddy Quinn on 2/14/25.
//

import SwiftUI
import SDWebImageSwiftUI
import MessageUI

struct OtherProfileView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var username: String
    @State var profilePic: String
    @State var description: String
    @State var userID: String
    @StateObject var viewModel = ListingViewModel()
    @Binding var showSignInView: Bool
    @State private var reportIsPresented: Bool = false
    @State private var isShowingMailView: Bool = false
    let reasonsToReport = ["Select a reason", "Scamming", "Inappropriate Profile", "Harassment", "Underage", "Something else"]
    @State var selectedReason = ""
    @State var reportReason: String
    var body: some View {
        NavigationStack{
            ScrollView(showsIndicators: false){
                HStack{
                    WebImage(url: URL(string: profilePic))
                        .resizable()
                        .resizable()
                        .scaledToFill()
                        .frame(width:65, height:65)
                        .clipShape(Circle())
                    Text(username)
                        .foregroundStyle(Color.foreground)
                        .font(Font.custom("ZingRustDemo-Base", size: 35))
                    Spacer()
                }
                HStack{
                    Text(description)
                        .foregroundColor(.gray)
                        .font(Font.custom("Jost-Regular", size: 20))
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                Divider()
                HStack{
                    Text("\(username)'s listings")
                        .foregroundStyle(Color.foreground)
                        .font(Font.custom("ZingRustDemo-Base", size: 25))
                    Spacer()
                }
                if viewModel.userRentListings.isEmpty {
                    HStack{
                        Text("No rentals")
                            .foregroundColor(.gray)
                            .font(Font.custom("Jost-Regular", size: 20))
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                } else {
                    HStack{
                        Text("Rentals")
                            .foregroundStyle(Color.foreground)
                            .font(Font.custom("Jost-Regular", size: 20))
                        Spacer()
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack{
                            Spacer()
                            ForEach(viewModel.userRentListings) { listing in
                                NavigationLink(destination: listingView(showSignInView: $showSignInView, listing: listing)) {
                                    imageBox(imageName: URL(string: listing.imageName![0]), carYear: listing.carYear!, carMake: listing.carMake!, carModel: listing.carModel!, carType: listing.carType!, width: 150, height: 150, textSize: 15)
                                }.frame(width:165)
                            }
                            Spacer()
                        }
                    }
                }
                Divider()
                if viewModel.userRentListings.isEmpty {
                    HStack{
                        Text("No auctions")
                            .foregroundColor(.gray)
                            .font(Font.custom("Jost-Regular", size: 20))
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                } else {
                    HStack{
                        Text("Auctions")
                            .foregroundStyle(Color.foreground)
                            .font(Font.custom("Jost-Regular", size: 20))
                        Spacer()
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack{
                            
                        }
                    }
                }
                Divider()
                if viewModel.userRentListings.isEmpty {
                    HStack{
                        Text("No listings for sale")
                            .foregroundColor(.gray)
                            .font(Font.custom("Jost-Regular", size: 20))
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                } else {
                    HStack{
                        Text("For sale")
                            .foregroundStyle(Color.foreground)
                            .font(Font.custom("Jost-Regular", size: 20))
                        Spacer()
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack{
                            
                        }
                    }
                }
                
            }
            .padding()
            .toolbar{
                ToolbarItem(placement: .principal) {
                    HStack{
                        HStack{
                            Button(action: {
                                dismiss()
                            }, label: {
                                backButton()
                            })
                            Spacer()
                        }
                        Button(action: {
                            reportIsPresented.toggle()
                        }, label: {
                            Image(systemName: "exclamationmark.octagon")
                                .resizable()
                                .foregroundColor(Color.accentColor)
                                .frame(width:30, height:30)
                        })
                    }
                }
            }
            .fullScreenCover(isPresented: $reportIsPresented) {
                VStack{
                    HStack{
                        Text("Report \(username)")
                            .font(.custom("ZingRustDemo-Base", size: 35))
                            .foregroundStyle(Color.foreground)
                        Spacer()
                        Button(action: {
                            dismiss()
                        }, label: {
                            Text("Cancel")
                                .underline()
                                .font(.custom("Jost", size: 20))
                                .foregroundStyle(Color.accentColor)
                        })
                    }
                    ScrollView(showsIndicators: false){
                        HStack{
                            Text("Why are you reporting this user?")
                                .font(.custom("Jost", size: 22))
                                .foregroundStyle(Color.foreground)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        HStack{
                            Picker("Report", selection: $selectedReason) {
                                ForEach(reasonsToReport, id: \.self) {
                                    Text($0)
                                }
                            }
                            Spacer()
                        }
                        
                        if selectedReason.isEmpty || selectedReason == "Select a reason" {
                            
                        } else {
                            VStack{
                                HStack{
                                    Text(selectedReason)
                                        .font(.custom("Jost", size: 22))
                                        .foregroundStyle(Color.foreground)
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                                TextField("Please tell us why you're reporting this user.", text: $reportReason, axis: .vertical)
                                    .padding(6)
                                    .frame(maxHeight: .infinity, alignment: .topLeading)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(.gray.opacity(0.2), lineWidth: 2)
                                    }
                                HStack{
                                    Spacer()
                                    Button(action: {
                                        self.isShowingMailView = true
                                    }, label: {
                                        HStack{
                                            Text("Send to Car Quest")
                                                .font(.custom("Jost", size: 18))
                                                .foregroundColor(.accentColor)
                                            
                                        }
                                    })
                                }
                            }
                        }
                    }
                }
                .padding()
                .sheet(isPresented: $isShowingMailView) {
                    MailComposerViewController(recipients: ["carquestreports@gmail.com"], subject: "\(selectedReason)", messageBody: "User reported: \(userID) \n Reason for report: \(reportReason)")
                       }
            }
        }
        .onAppear(){
            Task{
                do{
                    try viewModel.generateUserRentListings(userID: userID)
                } catch{ }
            }
        }
    }
    struct MailComposerViewController: UIViewControllerRepresentable {
        @Environment(\.dismiss) var dismiss
        var recipients: [String]
        var subject: String
        var messageBody: String

        func makeUIViewController(context: Context) -> MFMailComposeViewController {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = context.coordinator
            mailComposer.setToRecipients(recipients)
            mailComposer.setSubject(subject)
            mailComposer.setMessageBody(messageBody, isHTML: false)
            return mailComposer
        }

        func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}

        func makeCoordinator() -> Coordinator {
            return Coordinator(self)
        }

        class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
            var parent: MailComposerViewController

            init(_ parent: MailComposerViewController) {
                self.parent = parent
            }

            func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
                parent.dismiss()
            }
        }
    }
}

#Preview {
    OtherProfileView(username: "", profilePic: "", description: "", userID: "", showSignInView: .constant(false), reportReason: "")
}
