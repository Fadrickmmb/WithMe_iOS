//
//  Admin_TabView.swift
//  WithMe_iOS
//
//  Created by user264550 on 11/3/24.
//

import SwiftUI
import FirebaseAuth

struct Admin_TabView: View {
    @StateObject private var adminUserViewModel = Admin_UserViewModel()
    @State private var currentUserId: String = ""
    
    var body: some View {
        
        TabView{
                Admin_HomePage().tabItem{ Image(systemName: "house") }
                Admin_SearchPage().tabItem{ Image(systemName: "magnifyingglass") }
                User_AddPostPage().tabItem{ Image(systemName: "plus") }  // change it to admin page
                if adminUserViewModel.user != nil {
                    Admin_ProfilePage()
                        .tabItem {
                            Image(systemName: "person")
                        }
                } else {
                    Text("")
                        .tabItem {
                            Image(systemName: "person")
                        }
                }
            }.accentColor(.black)
                .onAppear{
                    if let user = Auth.auth().currentUser{
                        currentUserId = user.uid
                        adminUserViewModel.fetchUser(userId: currentUserId)
                    }
                }.navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
        
    }
}
