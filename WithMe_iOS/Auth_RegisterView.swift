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
        VStack {
            
            Image("withme_logo")
                .resizable()
                .frame(width: 252, height: 92)
                .padding(.top, 50)

            
            Text("Username")
                .font(.system(size: 16))
                .padding(.top, 20)
            TextField("Enter your username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .frame(height: 50)
                .padding(.horizontal)

            
            Text("Email")
                .font(.system(size: 16))
                .padding(.top, 10)
            TextField("Enter your email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .frame(height: 50)
                .padding(.horizontal)

           
            Text("Password")
                .font(.system(size: 16))
                .padding(.top, 10)
            SecureField("Enter your password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .frame(height: 50)
                .padding(.horizontal)

            
            Button(action: {
                registerUser()
            }) {
                Text("Register")
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, minHeight: 45)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 50)
                    .shadow(radius: 5)
            }
            .padding(.top, 20)
            .padding(.horizontal)

            
            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.top, 10)
            }

            Spacer()

            
            Text("Do You Have an Account? \nSign In Here")
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .padding(.top, 20)

            
            Text("Forgot Password")
                .foregroundColor(.blue)
                .padding(.top, 10)

            Spacer()
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
