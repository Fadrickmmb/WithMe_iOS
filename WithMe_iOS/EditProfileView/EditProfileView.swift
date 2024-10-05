import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseAuth

struct EditProfileView: View {
    @State private var profileImage: UIImage? = nil
    @State private var name: String = ""
    @State private var username: String = ""
    @State private var bio: String = ""
    @State private var newPassword: String = ""
    @State private var isLoggedOut = false
    
    // Loading state
    @State private var isLoading = false
    @State private var showSuccessPopup = false

    // Boolean to check if image picker is open
    @State private var isImagePickerOpen = false
    
    // Firebase user reference
    let user = Auth.auth().currentUser
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    TopNavigationView()
                    ZStack {
                        // Background color
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
                            // Profile Image
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
                            
                            // Profile Name and Action
                            VStack {
                                Text(username)
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
                            
                            // Profile Input Fields
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
                                
                                // Save Changes Button
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
                                
                                // Logout Button
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
                    .navigationBarBackButtonHidden(true)
                    Spacer()
                    TabBar()
                    // NavigationLink for redirecting to LoginView
//                    NavigationLink(
//                        destination: LoginView(),
//                        isActive: $isLoggedOut,
//                        label: { EmptyView() }
//                    )
                }
                
                // Loading indicator and blur effect
                if isLoading {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    ProgressView("Saving changes...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding(20)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(10)
                }
                
                // Success popup
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
    
    // Load Profile Data from Firebase
    private func loadProfileData() {
        guard let uid = user?.uid else { return }
        let db = Database.database().reference().child("users").child(uid)
        
        db.observeSingleEvent(of: .value) { snapshot in
            if let value = snapshot.value as? [String: Any] {
                self.name = value["name"] as? String ?? ""
                self.username = value["username"] as? String ?? ""
                self.bio = value["bio"] as? String ?? ""
                // Fetch and display the profile image
                if let profileImageUrl = value["profileImageUrl"] as? String {
                    downloadProfileImage(from: profileImageUrl)
                }
            }
        }
    }
    
    // Download the image from Firebase Storage
    private func downloadProfileImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Error converting image data.")
                return
            }
            
            DispatchQueue.main.async {
                self.profileImage = image
            }
        }.resume()
    }

    // Update Profile Data in Firebase
    private func updateProfile() {
        guard let uid = user?.uid else { return }
        let db = Database.database().reference().child("users").child(uid)
        
        var dataToUpdate = [
            "username": username,
            "bio": bio
        ]
        
        // Start loading indicator
        isLoading = true
        
        // Update password if it's not empty
        if !newPassword.isEmpty {
            user?.updatePassword(to: newPassword) { error in
                if let error = error {
                    print("Error updating password: \(error.localizedDescription)")
                } else {
                    print("Password updated successfully")
                }
            }
        }
        
        // Update profile image
        if let profileImage = profileImage {
            uploadProfileImage(image: profileImage) { url in
                if let url = url {
                    dataToUpdate["profileImageUrl"] = url.absoluteString
                }
                db.updateChildValues(dataToUpdate) { error, _ in
                    // Stop loading indicator and show success popup
                    self.isLoading = false
                    if let error = error {
                        print("Error updating profile: \(error.localizedDescription)")
                    } else {
                        print("Profile updated successfully")
                        showSuccessPopup = true
                    }
                }
            }
        } else {
            // Just update the text fields
            db.updateChildValues(dataToUpdate) { error, _ in
                // Stop loading indicator and show success popup
                self.isLoading = false
                if let error = error {
                    print("Error updating profile: \(error.localizedDescription)")
                } else {
                    print("Profile updated successfully")
                    showSuccessPopup = true
                }
            }
        }
    }
    
    // Upload profile image to Firebase Storage
    private func uploadProfileImage(image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let uid = user?.uid else { return }
        let storageRef = Storage.storage().reference().child("profile_images").child("\(uid).jpg")
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            completion(nil)
            return
        }
        
        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    completion(nil)
                } else {
                    completion(url)
                }
            }
        }
    }
    
    // Logout user
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
    EditProfileView()
}
