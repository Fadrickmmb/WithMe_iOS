//
//  User_HomePage.swift
//  WithMe_iOS
//
//  Created by user264550 on 9/27/24.

import SwiftUI
import Firebase
import FirebaseDatabase
import FirebaseAuth

struct User_HomePage: View {
    @State private var posts: [Post] = []
    @State private var isLoading = true

    let user = Auth.auth().currentUser

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading posts...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(posts) { post in
                                PostView(post: post)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarBackButtonHidden()
            .navigationBarBackButtonHidden(true)
            .onAppear {
                fetchPostsFromFirebase()
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarBackButtonHidden(true)
    }

    func fetchPostsFromFirebase() {
        guard let userId = user?.uid else {
            return
        }

        let ref = Database.database().reference().child("users").child(userId).child("posts")

        ref.observeSingleEvent(of: .value, with: { snapshot in
            var fetchedPosts: [Post] = []

            for child in snapshot.children.allObjects as? [DataSnapshot] ?? [] {
                if let dict = child.value as? [String: Any],
                   let postId = dict["postId"] as? String,
                   let userId = dict["userId"] as? String,
                   let name = dict["name"] as? String,
                   let postImageUrl = dict["postImageUrl"] as? String,
                   let location = dict["location"] as? String,
                   let postDate = dict["postDate"] as? String,
                   let content = dict["content"] as? String,
                   let comments = dict["comments"] as? [String: Any] {

                    let commentsNumber = comments.count
                    let yummys = 0
                    let userPhotoUrl = ""
                    let post = Post(postId: postId,
                                    userId: userId,
                                    name: name,
                                    postImageUrl: postImageUrl,
                                    userPhotoUrl: userPhotoUrl,
                                    yummys: yummys,
                                    location: location,
                                    postDate: postDate,
                                    commentsNumber: commentsNumber,
                                    content: content)
                    fetchedPosts.append(post)
                }
            }

            DispatchQueue.main.async {
                self.posts = fetchedPosts
                self.isLoading = false
            }
        })
    }
}

#Preview {
    User_HomePage()
}
