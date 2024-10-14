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
    var userPhotoUrl: String?
    var userBio: String?
    
    init(name: String, email: String, id: String) {
        self.name = name
        self.email = email
        self.id = id
        self.userPhotoUrl = nil
        self.userBio = nil
    }

    init(name: String, email: String, id: String, userPhotoUrl: String, userBio: String) {
        self.name = name
        self.email = email
        self.id = id
        self.userPhotoUrl = userPhotoUrl
        self.userBio = userBio
    }
}
