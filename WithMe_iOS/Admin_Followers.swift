//
//  Admin_Followers.swift
//  WithMe_iOS
//
//  Created by user264550 on 11/3/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct Admin_Followers: View {
    @StateObject private var adminFollowerViewModel = AdminFollowerViewModel()
    var currentUserId: String

    var body: some View {
        VStack {
            // Header Section
            HStack {
                Image("withme_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 70)
                Spacer()
                Image("withme_yummy")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                Image("withme_comment")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
            }
            
            HStack {
                NavigationLink(destination: Admin_TabView()) {
                    Image(systemName: "arrow.left")
                }
                Spacer()
                Text("Followers")
                    .font(.custom("DMSerifDisplay-Regular", size: 26))
                Spacer()
            }
            .padding()
            
            List(adminFollowerViewModel.followersList) { follower in
                NavigationLink(destination: Admin_ViewProfile(userId: follower.id)){
                    HStack {
                        let imageUrl = URL(string: follower.userPhotoUrl)
                        if (!follower.userPhotoUrl.isEmpty) {
                            AsyncImage(url: imageUrl) { image in
                                image.resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            } placeholder: {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            }
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        }
                        Text(follower.name).font(.custom("DMSerifDisplay-Regular", size: 20))
                    }
                    .padding(.vertical, 5)
                }
            }
            .listStyle(PlainListStyle())
        }
        .padding(.top, 80)
        .padding(.leading, 10)
        .padding(.trailing, 10)
        .onAppear {
            adminFollowerViewModel.fetchFollowers(userId: currentUserId)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}
//#Preview {
//    User_Followers()
//}
