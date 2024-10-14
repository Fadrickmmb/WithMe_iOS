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
                   let postDictionary = childSnapshot.value as? [String: Any] {
                    let postId = postDictionary["postId"] as? String ?? ""
                    let userId = postDictionary["userId"] as? String ?? ""
                    let name = postDictionary["name"] as? String ?? ""
                    let postImageUrl = postDictionary["postImageUrl"] as? String ?? ""
                    let userPhotoUrl = postDictionary["userPhotoUrl"] as? String ?? ""
                    let yummys = postDictionary["yummys"] as? Int ?? 0
                    let location = postDictionary["location"] as? String ?? ""
                    let postDate = postDictionary["postDate"] as? String ?? ""
                    let commentsNumber = postDictionary["commentNumbers"] as? Int ?? 0
                    
                    if (!postId.isEmpty) {
                        let post = Post(
                            postId: postId,
                            userId: userId,
                            name: name,
                            postImageUrl: postImageUrl,
                            userPhotoUrl: userPhotoUrl,
                            yummys: yummys,
                            location: location,
                            postDate: postDate,
                            commentsNumber: commentsNumber
                        )
                        posts.append(post)
                    }
                }
            }
            DispatchQueue.main.async {
                self.postList = posts
                print("Total posts loaded: \(posts.count)")
            }
        }
    }
}
