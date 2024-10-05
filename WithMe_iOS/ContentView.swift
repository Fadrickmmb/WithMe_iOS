//
//  ContentView.swift
//  WithMe_iOS
//
//  Created by Fadrick Barroso on 2024-09-22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                Image("withme_launcher")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: 530)
                    .clipped()
                    .edgesIgnoringSafeArea(.top)
                
                NavigationLink(destination: Auth_LoginView()) {
                    Text("Login")
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.1, green: 0.18, blue: 0.19))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.top, 20)
                }
                .frame(width: UIScreen.main.bounds.width * 0.4)
                
                NavigationLink(destination: Auth_RegisterView()) {
                    Text("Create an Account")
                        .font(.system(size: 16))
                        .padding(.top, 10)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
        }
    }
}

