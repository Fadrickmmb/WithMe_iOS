//
//  Admin_CreateUser.swift
//  WithMe_iOS
//
//  Created by Fadrick Barroso on 2024-10-29.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct Admin_CreateUser: View {
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var selectedRole = ""
    @State private var showAlert = false
    @State private var alertMessage = ""

    private let roles = ["Moderator", "Administrator"]
    private var auth = Auth.auth()
    private var adminDatabase = Database.database().reference().child("admin")
    private var modDatabase = Database.database().reference().child("mod")

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .padding(.horizontal)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Text("Select Role:")
                    .padding(.leading)

                ForEach(roles, id: \.self) { role in
                    RadioButton(title: role, selectedRole: $selectedRole)
                        .padding(.leading)
                }
                
                Button(action: createUser){
                    Text("Create")
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, minHeight: 45)
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 50)
                        .shadow(radius: 5)
                }
                .padding(.top, 10)
                .alert(isPresented: $showAlert){
                    Alert(title: Text(alertMessage))
                }
            
                NavigationLink(
                    destination: Admin_HomePage()
                ){
                    Text("Home Screen")
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, minHeight: 45)
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 50)
                        .shadow(radius: 5)
                }
                .padding(.top, 10)
            }
            .navigationTitle("Create New User")
        }
        .navigationBarBackButtonHidden(true)
    }

    private func createUser() {
        let trimmedUsername = username.trimmingCharacters(in: .whitespaces)
        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
        let trimmedPassword = password.trimmingCharacters(in: .whitespaces)

        guard !trimmedUsername.isEmpty else {
            showAlert(message: "Username is required")
            return
        }

        guard !trimmedEmail.isEmpty, trimmedEmail.contains("@") else {
            showAlert(message: "Valid email is required")
            return
        }

        guard !trimmedPassword.isEmpty, trimmedPassword.count >= 6 else {
            showAlert(message: "Password must be at least 6 characters")
            return
        }

        guard !selectedRole.isEmpty else {
            showAlert(message: "Please choose Mod or Admin")
            return
        }

        auth.createUser(withEmail: trimmedEmail, password: trimmedPassword) { result, error in
            if let error = error {
                showAlert(message: "User creation failed: \(error.localizedDescription)")
                return
            }

            guard let user = result?.user else { return }
            let newUser: [String: Any] = [
                "username": trimmedUsername,
                "email": trimmedEmail,
                "uid": user.uid
            ]

            if selectedRole == "Moderator" {
                modDatabase.child(user.uid).setValue(newUser)
            } else if selectedRole == "Administrator" {
                adminDatabase.child(user.uid).setValue(newUser)
            }

            showAlert(message: "User created successfully!")
        }
    }
    

    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}

struct RadioButton: View {
    let title: String
    @Binding var selectedRole: String

    var body: some View {
        Button(action: {
            selectedRole = title
        }) {
            HStack {
                Image(systemName: selectedRole == title ? "largecircle.fill.circle" : "circle")
                Text(title)
            }
        }
        .foregroundColor(.primary)
    }
}
