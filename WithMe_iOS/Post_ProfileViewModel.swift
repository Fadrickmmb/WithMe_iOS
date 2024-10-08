//
//  Post_ProfileViewModel.swift
//  WithMe_iOS
//
//  Created by user264550 on 10/7/24.
//

import SwiftUI
import FirebaseDatabase

class Post_ProfileViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var postList: [Post] = []
    
    private var ref: DatabaseReference = Database.database().reference()
    
    func fetchProfileData(userId: String) {
        ref.child("users").child(userId).observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                print("Failed to fetch user profile data")
                return
            }
            DispatchQueue.main.async {
                self.name = value["name"] as? String ?? "Unknown"
            }
        }
        
        ref.child("users").child(userId).child("posts").observe(.value) { snapshot in
            var posts: [Post] = []
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let postData = childSnapshot.value as? [String: Any],
                   let postId = postData["postId"] as? String,
                   let userId = postData["userId"] as? String,
                   let name = postData["name"] as? String,
                   let postImageUrl = postData["postImageUrl"] as? String,
                   let userPhotoUrl = postData["userPhotoUrl"] as? String,
                   let yummys = postData["yummys"] as? Int,
                   let location = postData["location"] as? String,
                   let postDate = postData["postDate"] as? String,
                   let commentsNumber = postData["commentsNumber"] as? Int {
                    
                    let post = Post(postId: postId, userId: userId, name: name, postImageUrl: postImageUrl, userPhotoUrl: userPhotoUrl, yummys: yummys, location: location, postDate: postDate, commentsNumber: commentsNumber)
                    posts.append(post)
                }
            }
            
            DispatchQueue.main.async {
                self.postList = posts
            }
        }
    }
}
