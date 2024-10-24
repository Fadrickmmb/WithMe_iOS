//
//  Post.swift
//  WithMe_iOS
//
//  Created by user264550 on 10/7/24.
//

import Foundation

struct Post: Identifiable {
    var id: String { postId }
    
    var postId: String
    var userId: String
    var name: String
    var postImageUrl: String
    var userPhotoUrl: String
    var yummys: Int
    var location: String
    var postDate: String
    var commentsNumber: Int
    var content: String
    
    init(postId: String, userId: String, name: String, postImageUrl: String, userPhotoUrl: String, yummys: Int, location: String, postDate: String, commentsNumber: Int, content: String) {
        self.postId = postId
        self.userId = userId
        self.name = name
        self.postImageUrl = postImageUrl
        self.userPhotoUrl = userPhotoUrl
        self.yummys = yummys
        self.location = location
        self.postDate = postDate
        self.commentsNumber = commentsNumber
        self.content = content
    }
}
