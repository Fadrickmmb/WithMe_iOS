//
//  User_PostModel.swift
//  WithMe_iOS
//
//  Created by user264550 on 10/7/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct User_PostPartialView: View {
    var postId: String
    var userId: String
    var name: String
    var postImageUrl: String
    var userPhotoUrl: String
    var postDate: String
    var yummys: Int
    var comments: Int
    var location: String
    @State private var showChangePostDialog = false
    @State private var showEditPostView = false
    @State private var isCurrentUser = false
    @State private var showReportPostDialog = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let url = URL(string: userPhotoUrl), !userPhotoUrl.isEmpty {
                    AsyncImage(url: url) { image in
                        image.resizable()
                             .aspectRatio(contentMode: .fill)
                             .frame(width: 50, height: 50)
                             .clipShape(Circle())
                    } placeholder: {
                        Image(systemName: "person.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }
                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                }

                VStack(alignment: .leading) {
                    Text(name)
                        .font(.custom("DMSerifDisplay-Regular", size: 20))
                    HStack {
                        Image(systemName: "location.fill")
                            .font(.system(size: 16))
                        Text(location)
                    }
                }
                Spacer()
                HStack(spacing: 5) {
                    Circle().frame(width: 7, height: 7)
                    Circle().frame(width: 7, height: 7)
                    Circle().frame(width: 7, height: 7)
                }.onTapGesture {
                    guard let currentUserId = Auth.auth().currentUser?.uid else {
                        return
                    }
                    if (userId == currentUserId){
                        isCurrentUser = true
                        showChangePostDialog = true
                    } else {
                        isCurrentUser = false
                        showReportPostDialog = true
                    }
                }
            }
            .padding(.vertical)

            if let imageUrl = URL(string: postImageUrl), !postImageUrl.isEmpty {
                AsyncImage(url: imageUrl) { image in
                    image.resizable()
                         .aspectRatio(contentMode: .fill)
                         .frame(maxHeight: 250)
                         .clipped()
                } placeholder: {
                    Image(systemName: "camera")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                }
            } else {
                Image(systemName: "camera")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
            }

            HStack {
                HStack {
                    Image("withme_yummy")
                        .resizable()
                        .frame(width: 25, height: 25)
                    Text("\(yummys)")
                        .font(.system(size: 12))
                }

                Spacer()

                HStack {
                    Image("withme_comment")
                        .resizable()
                        .frame(width: 25, height: 25)
                    Text("\(comments)")
                        .font(.system(size: 12))
                }

                Spacer()

                Text(postDate)
                    .font(.system(size: 12))
            }
            .padding(.vertical)
        }
        .padding()
        .sheet(isPresented: $showReportPostDialog) {
            ReportPostDialog(
                buttonTitle: "",
                action: {actionType in
                    //reportPost()
                },
                userId: userId,
                postId: postId,
                isShowing: $showReportPostDialog)
        }
        .sheet(isPresented: $showChangePostDialog) {
            ChangePostDialog(
                buttonTitle: "",
                action: { actionType in
                    if actionType == "delete" {
                        deletePost()
                    } else if actionType == "edit" {
                        showEditPostView = true
                    }
                },
                userId: userId,
                postId: postId,
                isShowing: $showChangePostDialog
            )
        }.navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .background(
            NavigationLink(
                destination: EditPostView(postId: postId),
                isActive: $showEditPostView,
                label: {
                    EmptyView()
                }
            )
        )
    }
    
    func deletePost(){
        let reference = Database.database().reference()
        reference.child("users").child(userId).child("posts").child(postId).removeValue {
            error, _ in
            if let error = error{
                print("Error deleting post: \(error.localizedDescription)")
            } else {
                print("Post deleted successfuly.")
            }
            
        }
    }
}

