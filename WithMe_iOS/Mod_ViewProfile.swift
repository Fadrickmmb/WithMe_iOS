//
//  Mod_ViewProfile.swift
//  WithMe_iOS
//
//  Created by Fadrick Barroso on 2024-10-29.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct Mod_ViewProfile: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var userViewModel = User_ViewModel()
    @StateObject private var postViewModel = Post_ProfileViewModel()
    @State private var navigateToEditProfile = false
    @State private var isFollowing = false
    @State private var isSuspended = false
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
                            Text("\(userViewModel.user?.followers.count ?? 0)")
                                .font(.custom("DMSerifDisplay-Regular", size: 22))
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
                            Text("\(userViewModel.user?.following.count ?? 0)")
                                .font(.custom("DMSerifDisplay-Regular", size: 22))
                            Text("Following")
                                .font(.system(size: 16))
                        }
                        .padding()
                    }
                    
                    Text(userViewModel.user?.userBio ?? "No bio available")
                        .font(.custom("DMSerifDisplay-Regular", size: 26))
                        .padding()
                    
                    HStack{
                        NavigationLink(
                            destination: Mod_TabView())
                        {
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
                        }
                        Spacer()
                        Button {
                            changeFollowStatus()
                        } label: {
                            Text(isFollowing ? "Unfollow" : "Follow")
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
                        }
                    }
                    HStack{
                        Button{
                            changeSuspensionStatus()
                        }label: {
                            Text(isSuspended ? "Unsuspend" : "Suspend")
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
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        ForEach(postViewModel.postList) { post in
                            NavigationLink(destination: Mod_PostView(
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
                                Admin_PostPartialView(
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
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.top)
                }
                .padding(.top, 0)
            }.edgesIgnoringSafeArea(.all)
        }.onAppear {
            checkFollowStatus()
            userViewModel.fetchUser(userId: userId)
            postViewModel.fetchProfileData(userId: userId)
        }.navigationBarBackButtonHidden(true)
    }
    private func changeFollowStatus(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return
        }
        let currentUserRef = Database.database().reference().child("users").child(currentUserId)
        let visitedUserRef = Database.database().reference().child("users").child(userId)
        
        let followingRef = currentUserRef.child("following").child(userId)
        let followersRef = visitedUserRef.child("followers").child(currentUserId)
        
        followingRef.observeSingleEvent(of: .value){snapshot in
            if(snapshot.exists()){
                followingRef.removeValue()
                followersRef.removeValue()
                isFollowing = false
            } else {
                followingRef.setValue(true)
                followersRef.setValue(true)
                isFollowing = true
            }
        }
    }
    
    private func checkFollowStatus(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return
        }
        let currentUserRef = Database.database().reference().child("users").child(currentUserId)
        currentUserRef.child("following").child(userId).observeSingleEvent(of: .value){snapshot in
            if(snapshot.exists()){
                isFollowing = true
            } else {
                isFollowing = false
            }
        }
    }
    
    private func checkSuspensionStatus() {
        let db = Database.database().reference()
        let suspendedRef = db.child("suspendedUsers").child(userId)

        suspendedRef.observeSingleEvent(of: .value) { snapshot in
            isSuspended = snapshot.exists()
        }
    }
    
    private func changeSuspensionStatus() {
        checkSuspensionStatus()
        
        let db = Database.database().reference()
        let suspendedRef = db.child("suspendedUsers").child(userId)

        if isSuspended {
            suspendedRef.removeValue { error, _ in
                if error == nil {
                    isSuspended = false
                } else {
                    print("Error unsuspending user: \(error!.localizedDescription)")
                }
            }
        } else {
            suspendedRef.setValue(true) { error, _ in
                if error == nil {
                    isSuspended = true
                } else {
                    print("Error suspending user: \(error!.localizedDescription)")
                }
            }
        }
        checkSuspensionStatus()
    }
    
}
//#Preview {
//    Mod_ViewProfile()
//}
