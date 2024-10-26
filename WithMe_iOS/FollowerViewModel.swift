//
//  FollowerViewModel.swift
//  WithMe_iOS
//
//  Created by user264550 on 10/25/24.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class FollowerViewModel: ObservableObject {
    @Published var followersList: [Follower] = []

    func fetchFollowers(userId: String) {
        let followersReference = Database.database().reference().child("users").child(userId).child("followers")
        
        followersReference.observeSingleEvent(of: .value) { snapshot in
            guard let followersDictionary = snapshot.value as? [String: Bool] else {
                return
            }
            self.followersList.removeAll()
            for (followerId, _) in followersDictionary {
                let followerRef = Database.database().reference().child("users").child(followerId)
                
                followerRef.observeSingleEvent(of: .value) { snapshot in
                    if let followerInfo = snapshot.value as? [String: Any]{
                        let name = followerInfo["name"] as? String ?? "Unknown"
                        let photoUrl = followerInfo["userPhotoUrl"] as? String ?? ""
                        let imageUrl = photoUrl.isEmpty ? "withme_yummy" : photoUrl
                        
                        let follower = Follower(id: followerId, name: name, userPhotoUrl: photoUrl)
                        DispatchQueue.main.async {
                            self.followersList.append(follower)
                        }
                    }
                }
            }
        }
    }
}
