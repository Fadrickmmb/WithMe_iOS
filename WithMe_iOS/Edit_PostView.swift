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
    @Environment(\.presentationMode) var presentationMode
    @State var currentUserId: String = ""
    @State private var editedContent: String = ""
    @State private var location: String = ""
    @State private var postImageUrl: String = ""
    @State private var image: UIImage? = nil
    @State private var showImagePicker = false
    
    var body: some View{
        VStack{
            Text("Edit Post")
                .font(.title)
                .padding()
            
            TextField("Edit content", text: $editedContent)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack{
                Text("Location: ").font(.headline)
                Text(location).font(.body)
            }.padding()
            
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .clipped()
                    .padding()
            }
            
            HStack{
                Button (action: {
                    showImagePicker = true
                }) {
                    Text("Change picture")
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                        .bold()
                        .frame(maxWidth: 120, maxHeight: 20)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.black)
                        )
                        .padding(.horizontal)
                }
            }
            .padding()
            Spacer()
            Button(action: {
                saveEditedPost()
            }) {
                Text("Save")
                    .foregroundColor(.white)
                    .font(.system(size: 16))
                    .bold()
                    .frame(maxWidth: 120, maxHeight: 20)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.black)
                    )
                    .padding(.horizontal)
            }
            .padding()
            Spacer()
        }
        .onAppear{
            
            if let user = Auth.auth().currentUser {
                currentUserId = user.uid
                loadPostInfo()
            }
        }.navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .padding()
            .sheet(isPresented: $showImagePicker){
                ImagePicker(image: $image)
            }
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
                location = postInfo["location"] as? String ?? ""
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
        
        if let updatedImage = image {
            let imageData = updatedImage.jpegData(compressionQuality: 0.8)
            let storageReference = Storage.storage().reference().child("posts/\(postId).jpg")
            
            if let imageData = imageData{
                storageReference.putData(imageData, metadata: nil) {metadata, error in
                    if let error = error {
                        print("Error uploading image: \(error.localizedDescription)")
                        return
                    }
                    storageReference.downloadURL{url, error in
                        if let error = error{
                            print("Error getting image url: \(error.localizedDescription)")
                            return
                        }
                        
                        if let downloadUrl = url?.absoluteString{
                            let updatedPostInfo = [
                                "content": editedContent,
                                "postImageUrl": downloadUrl
                            ]
                            reference.updateChildValues(updatedPostInfo){error, _ in
                                if let error = error {
                                    print("Error updating post info: \(error.localizedDescription)")
                                } else {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
