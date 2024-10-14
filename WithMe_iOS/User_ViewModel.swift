//
//  User_ViewModel.swift
//  WithMe_iOS
//
//  Created by user264550 on 10/7/24.
//

import Foundation
import FirebaseDatabase

class User_ViewModel: ObservableObject {
    @Published var user: User?
    
    func fetchUser(userId: String) {
        let ref = Database.database().reference().child("users").child(userId)
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let value = snapshot.value as? [String: Any] {
                let name = value["name"] as? String ?? ""
                let email = value["email"] as? String ?? ""
                let id = value["id"] as? String ?? ""
                //let numberPosts = value["numberPosts"] as? String ?? "0"
                //let numberFollowers = value["numberFollowers"] as? String ?? "0"
                //let numberFollowing = value["numberFollowing"] as? String ?? "0"
                let userPhotoUrl = value["userPhotoUrl"] as? String ?? ""
                let userBio = value["userBio"] as? String ?? ""
                
                DispatchQueue.main.async {
                    self.user = User(
                        name: name,
                        email: email,
                        id: id,
                //        numberPosts: numberPosts,
                //        numberFollowers: numberFollowers,
                //        numberFollowing: numberFollowing,
                        userPhotoUrl: userPhotoUrl,
                        userBio: userBio)
                }
            }
        }) { error in
            print("Error retrieving data: \(error.localizedDescription)")
        }
    }
}
