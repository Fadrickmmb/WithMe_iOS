//
//  Auth_ForgotPasswordView.swift
//  WithMe_iOS
//
//  Created by Fadrick Barroso on 2024-10-05.
//

import SwiftUI
import FirebaseAuth

struct Auth_ForgotPasswordView: View {
    @State private var email: String = ""
    @State private var isEmailSent = false
    @State private var showAlert = false
    @State private var alertMessage: String = ""

    var body: some View {
        NavigationView {
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

                VStack {
                    Image("withme_logo")
                        .resizable()
                        .frame(width: 252, height: 92)
                        .padding(.top, 50)

                    VStack {
                        Text("Email")
                            .font(.headline)

                        TextField("Email", text: $email)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(15)
                            .padding(.horizontal, 40)
                    }

                    Button("  RESET  ") {
                        resetPassword()
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .shadow(color: .gray, radius: 5))
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .padding()
                    Spacer()
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Notification"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func resetPassword() {
        guard !email.isEmpty else {
            alertMessage = "Please enter your email."
            showAlert = true
            return
        }


        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                alertMessage = "Error: \(error.localizedDescription)"
            } else {
                alertMessage = "A password reset email has been sent to \(email)."
            }
            showAlert = true
        }
    }
}

#Preview {
    Auth_ForgotPasswordView()
}