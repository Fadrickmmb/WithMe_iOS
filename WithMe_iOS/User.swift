//
//  User.swift
//  WithMe_iOS
//
//  Created by Fadrick Barroso on 2024-10-05.
//

import Foundation


struct User: Codable {
    var name: String
    var email: String
    var id: String
    var numberPosts: String?
    var numberFollowers: String?
    var numberYummys: String?
    var userPhotoUrl: String?
    var userBio: String?
    
    init(name: String, email: String, id: String) {
        self.name = name
        self.email = email
        self.id = id
        self.numberPosts = nil
        self.numberFollowers = nil
        self.numberYummys = nil
        self.userPhotoUrl = nil
        self.userBio = nil
    }

    init(name: String, email: String, id: String, numberPosts: String, numberFollowers: String, numberYummys: String, userPhotoUrl: String, userBio: String) {
        self.name = name
        self.email = email
        self.id = id
        self.numberPosts = numberPosts
        self.numberFollowers = numberFollowers
        self.numberYummys = numberYummys
        self.userPhotoUrl = userPhotoUrl
        self.userBio = userBio
    }
}
