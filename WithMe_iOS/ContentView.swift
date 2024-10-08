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
            ZStack {
                VStack(spacing: 0) {
                    
                    Image("withme_launcher")
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.6)
                        .clipped()
                        .edgesIgnoringSafeArea(.all)
                    
                    Spacer()
                }
                
                VStack(spacing: 20) {
                    NavigationLink(destination: Auth_LoginView()) {
                        Text("Login")
                            .font(.system(size: 16, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.1, green: 0.18, blue: 0.19))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.4)
                    
                    NavigationLink(destination: Auth_RegisterView()) {
                        Text("Create an Account")
                            .font(.system(size: 16))
                            .padding(.top, 10)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, 40)
            }
            .background(Color.white)
        }
    }
}
