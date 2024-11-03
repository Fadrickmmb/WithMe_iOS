//
//  Admin_CommentViewModel.swift
//  WithMe_iOS
//
//  Created by user264550 on 11/3/24.
//

import Foundation
import FirebaseDatabase

class Admin_CommentsViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    @Published var commentsNumber: Int = 0
    private var reference: DatabaseReference = Database.database().reference()

    func fetchComments(userId: String, postId: String) {
        reference.child("users").child(userId).child("posts").child(postId).child("comments").observe(.value) { snapshot in
            var fetchedComments: [Comment] = []

            guard snapshot.childrenCount > 0 else {
                print("No comments found.")
                DispatchQueue.main.async {
                    self.commentsNumber = 0
                }
                return
            }

            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let commentDict = childSnapshot.value as? [String: Any] {
                    let commentId = commentDict["commentId"] as? String ?? ""
                    let date = commentDict["date"] as? String ?? ""
                    let name = commentDict["name"] as? String ?? ""
                    let postId = commentDict["postId"] as? String ?? ""
                    let text = commentDict["text"] as? String ?? ""
                    let userId = commentDict["userId"] as? String ?? ""
                    
                    let comment = Comment(
                        name: name,
                        text: text,
                        date: date,
                        userId: userId,
                        postId: postId,
                        commentId: commentId
                    )
                    fetchedComments.append(comment)
                }
            }
            
            DispatchQueue.main.async {
                self.comments = fetchedComments
                self.commentsNumber = fetchedComments.count
            }
        }
    }
}
