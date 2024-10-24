//
//  Edit_PostView.swift
//  WithMe_iOS
//
//  Created by user264550 on 10/14/24.
//
import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

struct EditPostView: View {
    var postId: String
    @State var currentUserId: String = ""
    @State private var editedContent: String = ""
    @State private var editedLocation: String = ""
    @State private var postImageUrl: String = ""
    @State private var image: UIImage? = nil
    
    var body: some View{
        VStack{
            Text("Edit Post")
                .font(.title)
                .padding()
            
            TextField("Edit content", text: $editedContent)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Edit location", text: $editedLocation)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .clipped()
                    .padding()
            }
            
            Button(action: {
                saveEditedPost()
            }) {
                Text("Save")
                    .foregroundColor(.white)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.black))
            }
            .padding()
            Spacer()
        }
        .onAppear{
            loadPostInfo()
            if let user = Auth.auth().currentUser {
                currentUserId = user.uid
            }
        }
        .padding()
    }
    
    func loadImageFromFirebaseStorage(imageUrl: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let storageReference = Storage.storage().reference(forURL: imageUrl)
        
        storageReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let image = UIImage(data: data) {
                completion(.success(image))
            } else {
                completion(.failure(NSError(domain: "ImageErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred."])))
            }
        }
    }

    func loadPostInfo() {
        let reference = Database.database().reference().child("users").child(currentUserId).child("posts").child(postId)
        reference.observeSingleEvent(of: .value, with: { snapshot in
            if let postInfo = snapshot.value as? [String: Any] {
                editedContent = postInfo["content"] as? String ?? ""
                editedLocation = postInfo["location"] as? String ?? ""
                postImageUrl = postInfo["postImageUrl"] as? String ?? ""
                
                loadImageFromFirebaseStorage(imageUrl: postImageUrl) { result in
                    switch result {
                    case .success(let loadedImage):
                        self.image = loadedImage
                    case .failure(let error):
                        print("Failed to load image: \(error.localizedDescription)")
                    }
                }
            }
        })
    }

    func saveEditedPost() {
        let reference = Database.database().reference().child("users").child(currentUserId).child("posts").child(postId)
        
        let updatedPostData = [
            "content": editedContent,
            "location": editedLocation,
            "postImageUrl": postImageUrl
        ]
        
        reference.updateChildValues(updatedPostData) { error, _ in
            if let error = error {
                print("Error updating post: \(error.localizedDescription)")
            } else {
                print("Post updated successfully.")
            }
        }
    }
}
