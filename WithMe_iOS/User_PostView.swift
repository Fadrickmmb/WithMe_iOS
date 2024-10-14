//
//  User_PostView.swift
//  WithMe_iOS
//
//  Created by user264550 on 9/27/24.
//

import SwiftUI
import FirebaseAuth

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
    var onBack: ((String) -> Void)?
    @StateObject var commentViewModel = CommentsViewModel()
    @State private var currentUserId: String = ""
    

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
                    HStack(spacing: 5) {
                        Circle().frame(width: 7, height: 7)
                        Circle().frame(width: 7, height: 7)
                        Circle().frame(width: 7, height: 7)
                    }
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
                        onBack?(userId)
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
                    }.background(
                        NavigationLink(
                            destination: User_EditProfilePage(),
                            //isActive: $navigateToEditProfile,
                            label: { EmptyView() }
                        )
                    ).buttonStyle(PlainButtonStyle()).padding()
                   }
            }.onAppear{
                if let user = Auth.auth().currentUser{
                    currentUserId = user.uid
                    commentViewModel.fetchComments(userId: currentUserId, postId: postId)
                }
            }.navigationBarBackButtonHidden(true)
        }.padding(.leading,5).padding(.trailing,5)
    }
}

