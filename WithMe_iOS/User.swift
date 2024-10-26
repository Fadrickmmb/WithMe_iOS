//
//  User.swift
//  WithMe_iOS
//
//  Created by Fadrick Barroso on 2024-10-05.
//

import Foundation

struct User: Identifiable, Codable {
    var name: String
    var email: String
    var id: String
    var userPhotoUrl: String?
    var userBio: String?
    var posts: [String: Post] = [:]
    var following: [String: Bool] = [:]
    var followers: [String: Bool] = [:]
    
    init(){
        self.id = UUID().uuidString
        self.name = ""
        self.email = ""
        self.userPhotoUrl = nil
        self.userBio = nil
        self.posts = [:]
        self.following = [:]
        self.followers = [:]
    }
    
    init(name: String, email: String, id: String) {
        self.name = name
        self.email = email
        self.id = id
        self.userPhotoUrl = nil
        self.userBio = nil
        self.posts = [:]
        self.following = [:]
        self.followers = [:]
    }
    
    init(name: String, email: String, id: String, userPhotoUrl: String, userBio: String) {
        self.name = name
        self.email = email
        self.id = id
        self.userPhotoUrl = userPhotoUrl
        self.userBio = userBio
        self.posts = [:]
        self.following = [:]
        self.followers = [:]
    }
    
    init(name: String, email: String, id: String, userPhotoUrl: String, userBio: String, following: [String: Bool] = [:], followers: [String: Bool] = [:]) {
        self.name = name
        self.email = email
        self.id = id
        self.userPhotoUrl = userPhotoUrl
        self.userBio = userBio
        self.following = following
        self.followers = followers
    }
}
