//
//  Admin_EditProfilePage.swift
//  WithMe_iOS
//
//  Created by user264550 on 11/3/24.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseAuth

struct Admin_EditProfilePage: View {

    @State private var profileImage: UIImage? = nil
    @State private var name: String = ""
    @State private var username: String = ""
    @State private var bio: String = ""
    @State private var newPassword: String = ""
    @State private var isLoggedOut = false
    @State private var isLoading = true
    @State private var showSuccessPopup = false
    @State private var isImagePickerOpen = false
    @State private var navigateToUserProfile = false

    let user = Auth.auth().currentUser

    var body: some View {
        NavigationView {
            ZStack {
                    ScrollView {
                        VStack {
                            Image("withme_logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 70)
                        ZStack {
                            Color.white.ignoresSafeArea()
                                .overlay(
                                    Image(systemName: "circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 5)
                                        .foregroundColor(.gray)
                                        .opacity(0.1)
                                )

                            VStack(spacing: 20) {
                                if let profileImage = profileImage {
                                    Image(uiImage: profileImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white, lineWidth: 2)
                                        )
                                        .padding(.top, 10)
                                } else {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                        .padding(.top, 10)
                                }

                                VStack {
                                    Text(username.isEmpty ? "No Username" : username)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .padding(.all, 2)

                                    Text("Change Profile Picture")
                                        .foregroundColor(.blue)
                                        .underline()
                                        .onTapGesture {
                                            isImagePickerOpen.toggle()
                                        }
                                        .sheet(isPresented: $isImagePickerOpen) {
                                            ImagePicker(image: $profileImage)
                                        }
                                }

                                VStack(spacing: 20) {
                                    VStack {
                                        Text("Bio")
                                        TextField("Bio", text: $bio)
                                            .padding()
                                            .background(
                                                RoundedRectangle(cornerRadius: 25)
                                                    .fill(Color.gray.opacity(0.2))
                                            )
                                            .frame(height: 50)
                                            .padding(.horizontal, 50)
                                    }

                                    VStack {
                                        Text("Change Username")
                                        TextField("Username", text: $username)
                                            .padding()
                                            .background(
                                                RoundedRectangle(cornerRadius: 25)
                                                    .fill(Color.gray.opacity(0.2))
                                            )
                                            .frame(height: 50)
                                            .padding(.horizontal, 50)
                                    }

                                    VStack {
                                        Text("Change Password")
                                        SecureField("New Password", text: $newPassword)
                                            .padding()
                                            .background(
                                                RoundedRectangle(cornerRadius: 25)
                                                    .fill(Color.gray.opacity(0.2))
                                            )
                                            .frame(height: 50)
                                            .padding(.horizontal, 50)
                                    }

                                    Button(action: {
                                        updateProfile()
                                    }) {
                                        Text("Save Changes")
                                            .foregroundColor(.white)
                                            .fontWeight(.bold)
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(Color.blue)
                                            .cornerRadius(25)
                                            .padding(.horizontal, 50)
                                    }
                                    .padding(.top, 20)

                                    Button(action: {
                                        logout()
                                    }) {
                                        Text("Logout")
                                            .foregroundColor(.white)
                                            .fontWeight(.bold)
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(Color.red)
                                            .cornerRadius(25)
                                            .padding(.horizontal, 50)
                                    }
                                    .padding(.top, 10)
                                }
                                .padding(.top, 20)
                            }
                            .padding(.top, 20)
                        }
                    }
                    Spacer()
                    NavigationLink(
                        destination: Auth_LoginView(),
                        isActive: $isLoggedOut,
                        label: { EmptyView() }
                    )
                    NavigationLink(destination: Admin_ProfilePage(), isActive: $navigateToUserProfile,
                    label: {EmptyView()})
                }

                if isLoading {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    ProgressView("Loading profile...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding(20)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(10)
                }

                if showSuccessPopup {
                    VStack {
                        Text("Profile updated successfully!")
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                            .padding()

                        Button(action: {
                            showSuccessPopup = false
                            navigateToUserProfile = true
                        }) {
                            Text("OK")
                                .foregroundColor(.blue)
                        }
                    }
                    .background(Color.black.opacity(0.6).ignoresSafeArea())
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            loadProfileData()
        }
    }

    private func loadProfileData() {
        guard let uid = user?.uid else {
            isLoading = false
            return
        }
        let db = Database.database().reference().child("admin").child(uid)

        db.observeSingleEvent(of: .value) { snapshot in
            if let value = snapshot.value as? [String: Any] {
                self.username = value["name"] as? String ?? ""
                self.bio = value["userBio"] as? String ?? ""

                if let photoURLString = value["userPhotoUrl"] as? String,
                   let url = URL(string: photoURLString) {
                    fetchImage(from: url) { image in
                        self.profileImage = image
                    }
                }
            }
            self.isLoading = false
        }
    }

    private func fetchImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                completion(UIImage(data: data))
            }
        }.resume()
    }

    private func updateProfile() {
        guard let uid = user?.uid else { return }
        let db = Database.database().reference().child("admin").child(uid)

        self.isLoading = true

        var updatedData: [String: Any] = [
            "name": self.username,
            "userBio": self.bio
        ]

        if !newPassword.isEmpty {
            user?.updatePassword(to: newPassword) { error in
                if let error = error {
                    print("Error updating password: \(error.localizedDescription)")
                } else {
                    print("Password updated successfully")
                }
            }
        }

        if let profileImage = profileImage {
            uploadProfileImage(profileImage) { imageUrl in
                if let imageUrl = imageUrl {
                    updatedData["userPhotoUrl"] = imageUrl
                }
                db.updateChildValues(updatedData) { error, _ in
                    self.isLoading = false
                    if error == nil {
                        self.showSuccessPopup = true
                    }
                }
            }
        } else {
            db.updateChildValues(updatedData) { error, _ in
                self.isLoading = false
                if error == nil {
                    self.showSuccessPopup = true
                }
            }
        }
    }

    private func uploadProfileImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }

        let storageRef = Storage.storage().reference().child("user_profile_pictures/\(user?.uid ?? UUID().uuidString).jpg")

        storageRef.putData(imageData, metadata: nil) { _, error in
            guard error == nil else {
                completion(nil)
                return
            }
            storageRef.downloadURL { url, _ in
                completion(url?.absoluteString)
            }
        }
    }

    private func logout() {
        do {
            try Auth.auth().signOut()
            isLoggedOut = true
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

#Preview {
    Admin_EditProfilePage()
}
