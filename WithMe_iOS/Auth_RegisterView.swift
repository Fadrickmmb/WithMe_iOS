//
//  Auth_RegisterView.swift
//  WithMe_iOS
//
//  Created by Fadrick Barroso on 2024-10-04.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct Auth_RegisterView: View {
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""

    var body: some View {
        VStack(spacing: 20) {
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .keyboardType(.emailAddress)
                .autocapitalization(.none)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Register") {
                registerUser()
            }
            .padding()
            
            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }

    private func registerUser() {
        guard !username.isEmpty, !email.isEmpty, password.count >= 6 else {
            errorMessage = "Please fill in all fields with valid data."
            showError = true
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = "Registration failed: \(error.localizedDescription)"
                showError = true
                return
            }
            
            guard let user = authResult?.user else { return }
            let userId = user.uid
            let newUser = User(name: username, email: email, id: userId)

            let dbRef = Database.database().reference().child("users").child(userId)
            do {
                let data = try JSONEncoder().encode(newUser)
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    dbRef.setValue(json) { (error, ref) in
                        if let error = error {
                            errorMessage = "Failed to save user data: \(error.localizedDescription)"
                            showError = true
                        } else {
                            // Successful registration and data saving
                            // Navigate to the next view, e.g., HomePage
                        }
                    }
                }
            } catch {
                errorMessage = "Error encoding user data: \(error.localizedDescription)"
                showError = true
            }
        }
    }
}

#Preview {
    Auth_RegisterView()
}
