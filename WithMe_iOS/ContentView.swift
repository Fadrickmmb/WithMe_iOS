//
//  ContentView.swift
//  WithMe_iOS
//
//  Created by Fadrick Barroso on 2024-09-22.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    
    @State private var isAuthenticated = false
    
    var body: some View {
        if isAuthenticated {
            EditProfileView()
        } else {
            ProgressView("Logging in...") // Loading indicator while logging in
                .onAppear {
                   
                    Auth.auth().addStateDidChangeListener { auth, user in
                        if user != nil {
                            isAuthenticated = true
                        }
                    }
                }
        }
    }
}
