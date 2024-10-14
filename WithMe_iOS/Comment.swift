//
//  Comment.swift
//  WithMe_iOS
//
//  Created by user264550 on 10/13/24.
//
import Foundation
// codable let the structure be deserialized/serialized because of firebase

struct Comment: Identifiable, Codable {
    var id: String {commentId}
    var name: String
    var text: String
    var date: String
    var userId: String
    var postId: String
    var commentId: String
    
    init(){
        self.name = ""
        self.text = ""
        self.date = ""
        self.userId = ""
        self.postId = ""
        self.commentId = ""
    }
    
    init(name: String, text: String, date: String, userId: String, postId: String, commentId: String){
        self.name = name
        self.text = text
        self.date = date
        self.userId = userId
        self.postId = postId
        self.commentId = commentId
    }
}
