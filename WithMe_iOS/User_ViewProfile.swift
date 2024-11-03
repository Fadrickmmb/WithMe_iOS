//
//  User_ViewProfile.swift
//  WithMe_iOS
//
//  Created by Fadrick Barroso on 9/27/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct User_ViewProfile: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var userViewModel = User_ViewModel()
    @StateObject private var postViewModel = Post_ProfileViewModel()
    @State private var navigateToEditProfile = false
    @State private var isFollowing = false
    @State private var isReported = false
    @State private var reportUserStatus = "Report user"
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
                    }
                    
                    Text(userViewModel.user?.userBio ?? "No bio available")
                        .font(.custom("DMSerifDisplay-Regular", size: 26))
                        .padding()
                    
                    HStack{
                        NavigationLink(
                            destination: TabView_WithMe())
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
                    
                    Button {
                        reportUser()
                    } label: {
                        Text(isReported ? "User reported" : reportUserStatus)
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
                    }.disabled(isReported)
                    
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
            checkReportStatus()
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
    
    private func reportUser(){
        let reportUserRef = Database.database().reference().child("reportedUsers")
        let reportId = reportUserRef.childByAutoId().key
        
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let reportUserInfo: [String: Any]=[
            "reportId": reportId ?? "Unknown",
            "userId": userId,
            "userReportingId": currentUserId
        ]
        
        if let reportId = reportId {
            reportUserRef.child(reportId).setValue(reportUserInfo){error, _ in
                isReported = true
            }
        }
    }
    
    private func checkReportStatus(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let reportUserRef = Database.database().reference().child("reportedUsers").queryOrdered(byChild: "userReportingId")
            .queryEqual(toValue: currentUserId)
        
        reportUserRef.observeSingleEvent(of: .value) {snapshot in
            var reported = false
            
            if snapshot.exists(), let reports = snapshot.value as? [String: [String: Any]]{
                for report in reports.values {
                    if let reportedUserId = report["userId"] as? String, reportedUserId == userId{
                        reported = true
                        break
                    }
                }
            }
            
            DispatchQueue.main.async {
                isReported = reported
                reportUserStatus = reported ? "Reported" : "Report user"
            }
        }

    }
}
