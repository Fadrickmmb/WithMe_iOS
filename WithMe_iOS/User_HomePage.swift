//
//  User_HomePage.swift
//  WithMe_iOS
//
//  Created by user264550 on 9/27/24.

import SwiftUI
import Firebase
import FirebaseDatabase
import FirebaseAuth
import MapKit

struct User_HomePage: View {
    @State private var posts: [Post] = []
    @State private var isLoading = true
    @State private var selectedCoordinate: CLLocationCoordinate2D? = nil
    @State private var showingMapView = false
    @State private var isMapPresented = false
    @State private var selectedPost: Post? = nil
    @StateObject private var followingViewModel = FollowingViewModel()
    
    let user = Auth.auth().currentUser
    
    var body: some View {
        NavigationView {
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
                .padding()
                if isLoading {
                    ProgressView("Loading posts...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(posts) { post in
                                PostView(post: post, onLocationTap: {
                                    selectedPost = post
                                    isMapPresented = true
                                })
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                isLoading = true
                followingViewModel.fetchFollowing(userId: user?.uid ?? "") { followingUserIds in
                    fetchPostsFromMultipleUsers(userIds: followingUserIds)
                }
            }
            .sheet(isPresented: $isMapPresented) {
                if let post = selectedPost {
                    MapView(selectedCoordinate: .constant(CLLocationCoordinate2D(latitude: post.latitude, longitude: post.longitude)))
                }
            }
        }
    }

    func fetchPostsFromMultipleUsers(userIds: [String]) {
        var fetchedPosts: [Post] = []
        let dispatchGroup = DispatchGroup()
        
        for userId in userIds {
            dispatchGroup.enter()
            
            let ref = Database.database().reference().child("users").child(userId).child("posts")
            
            ref.observeSingleEvent(of: .value, with: { snapshot in
                for child in snapshot.children.allObjects as? [DataSnapshot] ?? [] {
                    if let dict = child.value as? [String: Any] {
                        let postId = dict["postId"] as? String ?? child.key
                        let userId = dict["userId"] as? String ?? "Unknown"
                        let name = dict["name"] as? String ?? dict["userName"] as? String ?? "Anonymous"
                        let postImageUrl = dict["postImageUrl"] as? String ?? ""
                        let location = dict["location"] as? String ?? "Unknown"
                        let postDate = dict["postDate"] as? String ?? ""
                        let content = dict["content"] as? String ?? ""
                        let comments = dict["comments"] as? [String: Any] ?? [:]
                        let commentsNumber = comments.count
                        let yummys = dict["yummys"] as? Int ?? 0
                        let userPhotoUrl = dict["userPhotoUrl"] as? String ?? ""
                        
                        let post = Post(postId: postId,
                                        userId: userId,
                                        name: name,
                                        postImageUrl: postImageUrl,
                                        userPhotoUrl: userPhotoUrl,
                                        yummys: yummys,
                                        location: location,
                                        postDate: postDate,
                                        commentsNumber: commentsNumber,
                                        content: content,
                                        latitude: dict["latitude"] as? Double ?? 0.0,
                                        longitude: dict["longitude"] as? Double ?? 0.0)
                        fetchedPosts.append(post)
                    } else {
                        print("Error processing post data for child: \(child.key)")
                    }
                }
                dispatchGroup.leave()
            })
        }
        
        dispatchGroup.notify(queue: .main) {
            self.posts = fetchedPosts
            self.isLoading = false
        }
    }
}
