//
//  Auth_LoginView.swift
//  WithMe_iOS
//
//  Created by Fadrick Barroso on 2024-10-05.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct Auth_LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var loginError: String?
    @State private var isAdmin: Bool = false
    @State private var navigateToAdmin: Bool = false
    @State private var navigateToUser: Bool = false
    @State private var userId: String?

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
                
                

                NavigationLink(destination: Auth_ForgotPasswordView()) {
                    Text("Forgot Pasword?")
                        .font(.system(size: 16))
                        .padding(.top, 10)
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
                
                
                NavigationLink(destination: Auth_RegisterView()) {
                    Text("Don't Have an Account?\nRegister Here")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 14))
                        .foregroundColor(.blue)
                        .padding(.top, 10)
                }
                .navigationBarBackButtonHidden(true)
                
                Spacer()


               
                NavigationLink(destination: Admin_HomePage(), isActive: $navigateToAdmin) {
                    EmptyView()
                }
                NavigationLink(destination: TabView_WithMe(), isActive: $navigateToUser) {
                    EmptyView()
                }
            }.navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
    }

    func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                loginError = "Failed to login: \(error.localizedDescription)"
            } else if let user = Auth.auth().currentUser{
                self.userId = user.uid
                checkUserRole()
            }
        }
    }

    
    func checkUserRole() {
        let dbRef = Database.database().reference()

        dbRef.child("admin").queryOrdered(byChild: "email").queryEqual(toValue: email).observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                navigateToAdmin = true
            } else {
                dbRef.child("users").queryOrdered(byChild: "email").queryEqual(toValue: email).observeSingleEvent(of: .value) { snapshot in
                    if snapshot.exists() {
                        navigateToUser = true
                    } else {
                        loginError = "User not found"
                    }
                }
            }
        }
    }
}

#Preview {
    Auth_LoginView()
}
