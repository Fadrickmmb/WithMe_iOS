//
//  Auth_LoginView.swift
//  WithMe_iOS
//
//  Created by Fadrick Barroso on 2024-10-05.
//

import SwiftUI
import FirebaseAuth

struct Auth_LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var loginError: String?

    var body: some View {
        NavigationView {
            VStack {
              
                Image("withme_logo")
                    .resizable()
                    .frame(width: 252, height: 92)
                    .padding(.top, 50)
                
                Text("Email")
                    .font(.system(size: 14))
                    .padding(.top, 20)


                TextField("Enter your email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding(.horizontal, 50)
                    .padding(.vertical, 10)
                    .cornerRadius(5)

                Text("Password")
                    .font(.system(size: 14))
                    .padding(.top, 20)

                
                SecureField("Enter your password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 50)
                    .padding(.vertical, 10)
                    .cornerRadius(5)

            
                Text("Forgot Password?")
                    .foregroundColor(.blue)
                    .font(.system(size: 14))
                    .padding(.top, 10)
                    .onTapGesture {
                        
                    }


                Button(action: loginUser) {
                    Text("Login")
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, minHeight: 45)
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 50)
                        .shadow(radius: 5)
                }
                .padding(.top, 30)

                if let error = loginError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, 10)
                        .padding(.horizontal, 50)
                }

                
                Text("Don't Have an Account?\nRegister Here")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.blue)
                    .font(.system(size: 14))
                    .padding(.top, 20)
                    .onTapGesture {
                        
                    }

                NavigationLink(destination: User_HomePage(), isActive: $isLoggedIn) {
                    EmptyView()
                }
            }
        }
    }

    func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                loginError = "Failed to login: \(error.localizedDescription)"
            } else {
                isLoggedIn = true
            }
        }
    }
}

#Preview {
    Auth_LoginView()
}
