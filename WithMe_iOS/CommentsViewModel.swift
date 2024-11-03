//
//  CommentsViewModel.swift
//  WithMe_iOS
//
//  Created by user264550 on 10/13/24.
//
import Foundation
import FirebaseDatabase

// Dict refers to a swift dictionary, similar to map<key, value> in android, i am using dict here but in the other codes i used dictionary to be easier to identify

class CommentsViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    @Published var commentsNumber: Int = 0
    private var reference: DatabaseReference = Database.database().reference()

    func fetchComments(userId: String, postId: String) {
        reference.child("users").child(userId).child("posts").child(postId).child("comments").observe(.value) { snapshot in
            var fetchedComments: [Comment] = []

            guard snapshot.childrenCount > 0 else {
                print("No comments found.")
                DispatchQueue.main.sync {
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
