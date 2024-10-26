//
//  FollowingViewModel.swift
//  WithMe_iOS
//
//  Created by user264550 on 10/25/24.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class FollowingViewModel: ObservableObject {
    @Published var followingList: [Follower] = []

    func fetchFollowing(userId: String) {
        let followingReference = Database.database().reference().child("users").child(userId).child("following")
        
        followingReference.observeSingleEvent(of: .value) { snapshot in
            guard let followingDictionary = snapshot.value as? [String: Bool] else {
                return
            }
            self.followingList.removeAll()
            for (followingId, _) in followingDictionary {
                let followingRef = Database.database().reference().child("users").child(followingId)
                
                followingRef.observeSingleEvent(of: .value) { snapshot in
                    if let followingInfo = snapshot.value as? [String: Any]{
                        let name = followingInfo["name"] as? String ?? "Unknown"
                        let photoUrl = followingInfo["userPhotoUrl"] as? String ?? ""
                        let imageUrl = photoUrl.isEmpty ? "withme_yummy" : photoUrl
                        
                        let following = Follower(id: followingId, name: name, userPhotoUrl: photoUrl)
                        DispatchQueue.main.async {
                            self.followingList.append(following)
                        }
                    }
                }
            }
        }
    }
}
