//
//  Admin_ProfilePage.swift
//  WithMe_iOS
//
//  Created by Fadrick Barroso on 2024-11-02.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct Admin_ProfilePage: View {
    @ObservedObject private var adminUserViewModel = Admin_UserViewModel()
    @ObservedObject private var userViewModel = User_ViewModel()
    @ObservedObject private var postViewModel = Admin_PostProfileViewModel()
    @State private var navigateToEditProfile = false
    @State private var currentUserId: String = ""
    @State private var numberPosts: Int = 0
    
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
                        NavigationLink(destination: Admin_Dashboard()){
                            Image(systemName: "menucard")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                        }
                        Image(systemName: "bell.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        
                    }

                    HStack {
                        if let photoUrl = adminUserViewModel.user?.userPhotoUrl, !photoUrl.isEmpty {
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
                    
                    Text(adminUserViewModel.user?.name.uppercased() ?? "")
                        .font(.custom("DMSerifDisplay-Regular", size: 26))
                        .padding().fixedSize(horizontal: true, vertical: false)
                    
                    HStack {
                       NavigationLink(destination: User_Followers(currentUserId: currentUserId)){
                            VStack {
                                Text("\(adminUserViewModel.user?.followers.count ?? 0)")
                                    .font(.custom("DMSerifDisplay-Regular", size: 22))
                                Text("Followers")
                                    .font(.system(size: 16))
                            }
                        }
                        .padding()
                        
                        VStack {
                            Text("\(postViewModel.postList.count)")
                                .font(.custom("DMSerifDisplay-Regular", size: 22))
                            Text("Posts").font(.system(size: 16))
                        }
                        .padding()
                        
                        NavigationLink(destination: User_Following(currentUserId: currentUserId)){
                            VStack{
                                Text("\(adminUserViewModel.user?.following.count ?? 0)")
                                    .font(.custom("DMSerifDisplay-Regular", size: 22))
                                Text("Following")
                                    .font(.system(size: 16))
                            }
                            .padding()
                        }
                    }
                    
                    Text("Bio").font(.custom("DMSerifDisplay-Regular", size: 22))
                        .padding()
                    
                    Text(adminUserViewModel.user?.userBio ?? "No bio available")
                        .font(.custom("DMSerifDisplay-Regular", size: 26))
                        .padding()
                    
                    Button {
                        navigateToEditProfile = true
                    } label: {
                        Text("Edit Profile")
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
                            destination: Admin_EditProfilePage(),
                            isActive: $navigateToEditProfile,
                            label: { EmptyView() }
                        )
                    ).buttonStyle(PlainButtonStyle())
                    
                    VStack(alignment: .leading) {
                        if(postViewModel.postList.isEmpty){
                            Text("No posts available.").foregroundColor(.gray).padding()
                        } else {
                            ForEach(postViewModel.postList) { post in
                                NavigationLink(destination: User_PostView(
                                    postId: post.postId,
                                    userId: post.userId,
                                    name: post.name,
                                    postImageUrl: post.postImageUrl,
                                    userPhotoUrl: post.userPhotoUrl,
                                    postDate: post.postDate,
                                    yummys: post.yummys,
                                    commentsNumber: post.commentsNumber,
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
                                        location: post.location,
                                        commentsNumber: post.commentsNumber
                                    )
                                }
                            }
                        }
                    }
                    .padding(.top)
                }
                .padding(.top, 0)
            }
        }
        .onAppear {
            if let user = Auth.auth().currentUser{
                currentUserId = user.uid
                adminUserViewModel.fetchUser(userId: currentUserId)
                postViewModel.fetchProfileData(userId: currentUserId)
            }
        }.padding(.leading,5).padding(.trailing,5)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
    }
}

//#Preview {
  //  User_ProfilePage(userId: userID)
//}
