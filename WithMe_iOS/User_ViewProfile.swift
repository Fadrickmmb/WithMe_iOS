//
//  User_ViewProfile.swift
//  WithMe_iOS
//
//  Created by Fadrick Barroso on 9/27/24.
//

import SwiftUI

struct User_ViewProfile: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var userViewModel = User_ViewModel()
    @StateObject private var postViewModel = Post_ProfileViewModel()
    @State private var navigateToEditProfile = false
    var userId: String
    
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView(.vertical) {
                VStack {
                    
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
                    .padding(.top,80)
                    
                    HStack {
                        if let photoUrl = userViewModel.user?.userPhotoUrl, !photoUrl.isEmpty {
                            AsyncImage(url: URL(string: photoUrl)){ image in
                                image.resizable()
                                    .frame(width: 180, height: 180)
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(Circle())
                            } placeholder: {
                                Image("withme_logo")
                                    .resizable()
                                    .frame(width: 180, height: 180)
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(Circle())
                            }
                        } else {
                            Image("withme_logo")
                                .resizable()
                                .frame(width: 180, height: 180)
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                        }
                    }
                    .padding()
                    
                    Text(userViewModel.user?.name.uppercased() ?? "Loading...")
                        .font(.custom("DMSerifDisplay-Regular", size: 26))
                        .padding()
                    
                    HStack {
                        VStack {
                            //Text(userViewModel.user?.numberFollowers ?? "0")
                            //    .font(.custom("DMSerifDisplay-Regular", size: 22))
                            Text("Followers")
                                .font(.system(size: 16))
                        }
                        .padding()
                        
                        VStack {
                            Text("\(postViewModel.postList.count)")
                                .font(.custom("DMSerifDisplay-Regular", size: 22))
                            Text("Posts")
                                .font(.system(size: 16))
                        }
                        .padding()
                        
                        VStack {
                            //Text(userViewModel.user?.numberFollowing ?? "0")
                            //   .font(.custom("DMSerifDisplay-Regular", size: 22))
                            Text("Following")
                                .font(.system(size: 16))
                        }
                        .padding()
                    }
                    
                    Text(userViewModel.user?.userBio ?? "No bio available")
                        .font(.custom("DMSerifDisplay-Regular", size: 26))
                        .padding()
                    
                    HStack{
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Back")
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                                .bold()
                                .frame(maxWidth: 120, maxHeight: 20)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(Color.black)
                                )
                                .padding(.horizontal)
                        }.background(
                            NavigationLink(
                                destination: User_EditProfilePage(),
                                isActive: $navigateToEditProfile,
                                label: { EmptyView() }
                            )
                        )
                        Spacer()
                        Button {
                            //add follow function here
                        } label: {
                            Text("Follow")
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                                .bold()
                                .frame(maxWidth: 120, maxHeight: 20)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(Color.black)
                                )
                                .padding(.horizontal)
                        }.background(
                            NavigationLink(
                                destination: User_EditProfilePage(),
                                isActive: $navigateToEditProfile,
                                label: { EmptyView() }
                            )
                        )
                    }
                    
                    VStack(alignment: .leading) {
                        ForEach(postViewModel.postList) { post in
                            NavigationLink(destination: User_PostView(
                                postId: post.postId,
                                userId: post.userId,
                                name: post.name,
                                postImageUrl: post.postImageUrl,
                                userPhotoUrl: post.userPhotoUrl,
                                postDate: post.postDate,
                                yummys: post.yummys,
                                comments: post.commentsNumber,
                                location: post.location,
                                content: post.content
                            )) {
                                User_PostPartialView(
                                    postId: post.postId,
                                    userId: post.userId,
                                    name: post.name,
                                    postImageUrl: post.postImageUrl,
                                    userPhotoUrl: post.userPhotoUrl,
                                    postDate: post.postDate,
                                    yummys: post.yummys,
                                    comments: post.commentsNumber,
                                    location: post.location
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.top)
                }
                .padding(.top, 0)
            }.edgesIgnoringSafeArea(.all)
        }.onAppear {
            userViewModel.fetchUser(userId: userId)
            postViewModel.fetchProfileData(userId: userId)
        }.navigationBarBackButtonHidden(true)
    }
}
//#Preview {
  //  User_ViewProfile()
//}
