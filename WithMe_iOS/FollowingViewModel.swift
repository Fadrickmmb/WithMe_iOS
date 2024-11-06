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

    func fetchFollowing(userId: String,completion: (([String]) -> Void)? = nil) {
        let followingReference = Database.database().reference().child("users").child(userId).child("following")
        
        followingReference.observeSingleEvent(of: .value) { snapshot in
            guard let followingDictionary = snapshot.value as? [String: Bool] else {
                completion?([]) // Return an empty array if no data is found
                return
            }
            
            var followingUserIds: [String] = []
            self.followingList.removeAll()
            
            let dispatchGroup = DispatchGroup()
            
            for (followingId, _) in followingDictionary {
                dispatchGroup.enter()
                let followingRef = Database.database().reference().child("users").child(followingId)
                
                followingRef.observeSingleEvent(of: .value) { snapshot in
                    if let followingInfo = snapshot.value as? [String: Any] {
                        let name = followingInfo["name"] as? String ?? "Unknown"
                        let photoUrl = followingInfo["userPhotoUrl"] as? String ?? ""
                        let imageUrl = photoUrl.isEmpty ? "withme_yummy" : photoUrl
                        
                        let following = Follower(id: followingId, name: name, userPhotoUrl: photoUrl)
                        DispatchQueue.main.async {
                            self.followingList.append(following)
                        }
                        followingUserIds.append(followingId)
                    }
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                completion?(followingUserIds) // Pass back the following user IDs after all are fetched
            }
        }
    }

}
