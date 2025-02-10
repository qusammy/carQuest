//
//  ReviewView.swift
//  carQuest
//
//  Created by hollande_894789 on 1/31/25.
//

import SwiftUI

struct ReviewView: View {
    @Environment(\.dismiss) var dismiss
    @State var listing: carListing?
    @State var review: Review
    @State var userVM = UserProfileViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                Text("Leave a Review")
                    .foregroundColor(Color.foreground)
                    .font(.custom("ZingRustDemo-Base", size: 35))
                Spacer()
                Text("Click to rate")
                    .foregroundColor(Color.foreground)
                    .font(.custom("Jost", size: 20))
                HStack {
                    StarsView(rating: $review.rating)
                        
                }.padding(.bottom)
                VStack(alignment: .leading) {
                    Text("Review Title:")
                        .bold()
                    TextField("title", text: $review.title)
                        .textFieldStyle(.roundedBorder)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray.opacity(0.5), lineWidth: 2)
                        }
                    Text("Review")
                        .bold()
                    TextField("review", text: $review.body, axis: .vertical)
                        .padding(.horizontal, 6)
                        .frame(maxHeight: .infinity, alignment: .topLeading)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray.opacity(0.5), lineWidth: 2)
                        }
                }
                .padding(.horizontal)
                .font(.title2)
                Spacer()
            }.onAppear {
                Task {
                    do {
                        review.userID = try AuthenticationManager.shared.getAuthenticatedUser().uid
                        review.userImage = userVM.carUser?.profileImageURL ?? ""
                        review.userName = userVM.carUser?.display_name ?? ""
                    }catch {
                        
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        Task{
                            do{
                                let user = try AuthenticationManager.shared.getAuthenticatedUser().uid
                                
                                try await FirebaseManager.shared.firestore.collection("carListings").document((listing?.listingID)!).collection("reviews").document(user).setData(review.dictionary)
                            }catch {
                                
                            }
                        }
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ReviewView(review: Review())
}
