//
//  Mod_PostProfileViewModel.swift
//  WithMe_iOS
//
//  Created by user264550 on 11/3/24.
//

import SwiftUI
import FirebaseDatabase


class Mod_PostProfileViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var postList: [Post] = []
    
    private var reference: DatabaseReference = Database.database().reference()
    
    func fetchProfileData(userId: String) {
        self.postList = []
        reference.child("mod").child(userId).observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                print("Failed to fetch user profile data")
                return
            }
            DispatchQueue.main.async {
                self.name = value["name"] as? String ?? "Unknown"
            }
        }
        
        reference.child("mod").child(userId).child("posts").observeSingleEvent(of: .value) { snapshot in
            var posts: [Post] = []
            if let postsDictionary = snapshot.value as? [String: Any] {
                for (postId, postValue) in postsDictionary {
                    if let postDictionary = postValue as? [String: Any] {
                        let userId = postDictionary["userId"] as? String ?? ""
                        let name = postDictionary["name"] as? String ?? ""
                        let postImageUrl = postDictionary["postImageUrl"] as? String ?? ""
                        let userPhotoUrl = postDictionary["userPhotoUrl"] as? String ?? ""
                        let yummys = postDictionary["yummys"] as? Int ?? 0
                        let location = postDictionary["location"] as? String ?? ""
                        let postDate = postDictionary["postDate"] as? String ?? ""
                        let commentsNumber = postDictionary["commentsNumber"] as? Int ?? 0
                        let content = postDictionary["content"] as? String ?? ""
                        
                        let post = Post(
                            postId: postId,
                            userId: userId,
                            name: name,
                            postImageUrl: postImageUrl,
                            userPhotoUrl: userPhotoUrl,
                            yummys: yummys,
                            location: location,
                            postDate: postDate,
                            commentsNumber: commentsNumber,
                            content: content
                        )
                        posts.append(post)
                        print("Loaded post: \(postId) - \(name)")
                    } else {
                        print("Failed to cast postValue to [String: Any] for postId: \(postId)")
                    }
                }
            } else {
                print("Failed to cast snapshot.value to [String: Any]")
            }
            
            DispatchQueue.main.async {
                self.postList = posts
                print("Total posts loaded: \(self.postList.count)")
            }
        }
    }
}
