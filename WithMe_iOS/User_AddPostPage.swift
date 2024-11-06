//
//  User_AddPostPage.swift
//  WithMe_iOS
//
//  Created by user264550 on 9/27/24.
//

import SwiftUI
import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import GoogleMaps

struct User_AddPostPage: View {
    
    @State private var profileImage: UIImage? = UIImage(systemName: "person.circle.fill")
    @State private var isImagePickerPresented = false
    @State private var location: String = ""
    @State private var description: String = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var postCreated = false
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @State private var isMapPresented = false

    var body: some View {
        ScrollView { 
            VStack {
                HStack {
                    Image("withme_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 70)
                    Spacer()
                    Image("withme_yummy")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                    Image("withme_comment")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                }
                .padding()

                VStack {
                    if let profileImage = profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                            .padding(.top, 20)
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                            .padding(.top, 20)
                    }
                    
                    Button(action: {
                        isImagePickerPresented = true
                    }) {
                        Text("Add Photo")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 150, height: 40)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                }
                
                Text("Tap on the map to select a location:")
                    .font(.headline)
                    .padding(.top, 20)
                
                Button(action: {
                    isMapPresented = true
                }) {
                    Text("Select Location")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(25)
                }
                .padding(.top, 20)

                Text("Selected Location: \(location.isEmpty ? "Location not set" : location)")
                    .padding(.top, 10)
                
                MapView(selectedCoordinate: $selectedCoordinate)
                    .frame(height: 300)
                    .cornerRadius(10)
                    .padding()

                HStack {
                    Image(systemName: "mappin.circle")
                        .foregroundColor(.gray)
                    
                    TextField("Enter Location",
                              text: $location)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(25)
                }
                .padding(.horizontal, 50)
                .padding(.top, 10)
                
                TextField("Add Description", text: $description)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(25)
                    .frame(height: 100)
                    .padding(.horizontal, 50)
                    .padding(.top, 20)
                Spacer()
                
                Button(action: {
                    guard let profileImage = profileImage else {
                        errorMessage = "Please select an image"
                        return
                    }
                    isLoading = true
                    createPost(image: profileImage, location: location, description: description)
                }) {
                    Text("Post")
                        .fontWeight(.bold)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                }
                .padding(.bottom, 20)
                
                if isLoading {
                    ProgressView("Posting...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(image: $profileImage)
            }
            .alert(isPresented: $postCreated) {
                Alert(title: Text("Success!"), message: Text("Your post has been uploaded."), dismissButton: .default(Text("OK")))
            }
            .fullScreenCover(isPresented: $isMapPresented) {
                MapSelectionView(selectedCoordinate: $selectedCoordinate, selectedLocation: $location, isMapPresented: $isMapPresented)
            }
        }
    }

    func createPost(image: UIImage, location: String, description: String) {
        uploadImage(image) { result in
            switch result {
            case .success(let imageURL):
                guard let currentUser = FirebaseManager.shared.auth.currentUser else {
                    errorMessage = "User not authenticated"
                    isLoading = false
                    return
                }
                
                let userId = currentUser.uid
                let username = currentUser.displayName ?? "Anonymous"
                let postId = UUID().uuidString
                let postDate = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)

                let latitude = selectedCoordinate?.latitude ?? 0.0
                let longitude = selectedCoordinate?.longitude ?? 0.0
                
                let postData: [String: Any] = [
                    "postId": postId,
                    "userId": userId,
                    "name": username,
                    "location": location,
                    "latitude": latitude,
                    "longitude": longitude,
                    "postImageUrl": imageURL,
                    "postDate": postDate,
                    "content": description,
                    "yummys": 0,
                    "commentsNumber": 0
                ]
                
                let userPostsRef = FirebaseManager.shared.databaseRef.child("users").child(userId).child("posts").child(postId)
                
                userPostsRef.setValue(postData) { error, _ in
                    DispatchQueue.main.async {
                        isLoading = false
                        if let error = error {
                            errorMessage = "Failed to create post: \(error.localizedDescription)"
                        } else {
                            postCreated = true
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    isLoading = false
                    errorMessage = "Image upload failed: \(error.localizedDescription)"
                }
            }
        }
    }

    func uploadImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        let storageRef = Storage.storage().reference().child("posts/\(UUID().uuidString).jpg")
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "Image Error", code: 400, userInfo: [NSLocalizedDescriptionKey: "Image data is not available"])))
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        storageRef.putData(imageData, metadata: metadata) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let downloadURL = url?.absoluteString {
                    completion(.success(downloadURL))
                }
            }
        }
    }
}

struct MapSelectionView: View {
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    @Binding var selectedLocation: String
    @Binding var isMapPresented: Bool

    var body: some View {
        VStack {
            Text("Select Your Location")
                .font(.headline)
                .padding()

            MapView(selectedCoordinate: $selectedCoordinate)
                .frame(height: 400)
                .cornerRadius(10)

            Button(action: {
                if let coordinate = selectedCoordinate {
                    CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { placemarks, error in
                        if let placemark = placemarks?.first {
                            selectedLocation = placemark.name ?? "Unknown Location"
                        }
                    }
                }
                isMapPresented = false
            }) {
                Text("Confirm Location")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            Spacer()
        }
    }
}
