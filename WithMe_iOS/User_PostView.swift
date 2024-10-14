//
//  User_PostView.swift
//  WithMe_iOS
//
//  Created by user264550 on 9/27/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct User_PostView: View {
    @Environment(\.presentationMode) var presentationMode
    var postId: String
    var userId: String
    var name: String
    var postImageUrl: String
    var userPhotoUrl: String
    var postDate: String
    var yummys: Int
    var comments: Int
    var location: String
    var content: String
    @StateObject var commentViewModel = CommentsViewModel()
    @State private var currentUserId: String = ""
    @State private var showCommentDialog = false
    @State private var commentText: String = ""    

    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading) {
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
                    
                }
                .padding(.vertical, 5)

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
                .padding(.vertical,5)
                
                Text(content).fontWeight(.bold)
                    .font(.system(size: 16))
                    .padding(.trailing, 10)
                if(commentViewModel.comments.isEmpty){
                    Text("No comments yet.")
                        .padding()
                } else {
                    List(commentViewModel.comments) {comment in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(comment.name)
                                    .fontWeight(.bold)
                                    .font(.system(size: 16))
                                    .padding(.trailing, 10)
                                Text(comment.date)
                                    .font(.system(size: 16))
                            }
                            Text(comment.text)
                                .font(.system(size: 16))
                                .padding(.bottom,5)
                        }
                    }.padding(0)
                }
                
                HStack{
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Back")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .bold()
                            .frame(maxWidth: 100, maxHeight: 20)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(Color.black)
                            )
                            .padding(.horizontal)
                        }.buttonStyle(PlainButtonStyle())
                    
                    Button {
                        showCommentDialog = true
                    } label: {
                        Text("Comment")
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
                    }.buttonStyle(PlainButtonStyle()).padding()
                   }
            }.onAppear{
                if let user = Auth.auth().currentUser{
                    currentUserId = user.uid
                    commentViewModel.fetchComments(userId: currentUserId, postId: postId)
                }
            }.navigationBarBackButtonHidden(true)
             .sheet(isPresented: $showCommentDialog) {
                CommentDialog(commentText: $commentText, isShowing: $showCommentDialog, buttonTitle: "Comment"){
                addComment()
                    }
             }
        }.padding(.leading,5)
         .padding(.trailing,5)
    }
    
    func addComment() {
        guard !commentText.isEmpty else {
            return
        }
        
        let commentId = UUID().uuidString
        let date = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)
        let comment = Comment(
            name: name,
            text: commentText,
            date: date,
            userId: currentUserId,
            postId: postId,
            commentId: commentId
        )
        
        let reference = Database.database().reference()
        reference.child("users").child(userId).child("posts").child(postId).child("comments").child(commentId).setValue([
            "name": comment.name,
            "text": comment.text,
            "date": comment.date,
            "userId": comment.userId,
            "postId": comment.postId,
            "commentId": comment.commentId
        ])
        commentViewModel.fetchComments(userId: userId, postId: postId)
        commentText = ""
        showCommentDialog = false
    }
}

