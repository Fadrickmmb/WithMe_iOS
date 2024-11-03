//
//  Mod_UserViewModel.swift
//  WithMe_iOS
//
//  Created by user264550 on 11/3/24.
//

import Foundation
import FirebaseDatabase

class Mod_UserViewModel: ObservableObject {
    @Published var user: User?
    
    func fetchUser(userId: String) {
        let reference = Database.database().reference().child("mod").child(userId)
        
        reference.observeSingleEvent(of: .value, with: { snapshot in
            guard let userInfo = snapshot.value as? [String: Any] else {
                print("No user data found")
                return
            }
            
            let name = userInfo["name"] as? String ?? ""
            let email = userInfo["email"] as? String ?? ""
            let id = userInfo["id"] as? String ?? ""
            let followers = userInfo["followers"] as? [String: Bool] ?? [:]
            let following = userInfo["following"] as? [String: Bool] ?? [:]
            let userPhotoUrl = userInfo["userPhotoUrl"] as? String ?? ""
            let userBio = userInfo["userBio"] as? String ?? ""
                
            DispatchQueue.main.async {
                    self.user = User(
                        name: name,
                        email: email,
                        id: id,
                        userPhotoUrl: userPhotoUrl,
                        userBio: userBio,
                        following: following,
                        followers: followers)
                }
            }
        ) {
            error in
            print("Error retrieving data: \(error.localizedDescription)")
        }
    }
}
