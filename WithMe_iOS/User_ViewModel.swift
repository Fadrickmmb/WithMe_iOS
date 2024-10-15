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
        let reference = Database.database().reference().child("users").child(userId)
        
        reference.observeSingleEvent(of: .value, with: { snapshot in
            guard let userInfo = snapshot.value as? [String: Any] else {
                print("No user data found")
                return
            }
            
            let name = userInfo["name"] as? String ?? ""
            let email = userInfo["email"] as? String ?? ""
            let id = userInfo["id"] as? String ?? ""
            //let numberPosts = value["numberPosts"] as? String ?? "0"
            //let numberFollowers = value["numberFollowers"] as? String ?? "0"
            //let numberFollowing = value["numberFollowing"] as? String ?? "0"
            let userPhotoUrl = userInfo["userPhotoUrl"] as? String ?? ""
            let userBio = userInfo["userBio"] as? String ?? ""
                
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
        ) {
            error in
            print("Error retrieving data: \(error.localizedDescription)")
        }
    }
}
