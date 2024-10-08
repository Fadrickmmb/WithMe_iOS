//
//  TabView_WithMe.swift
//  WithMe_iOS
//
//  Created by user264550 on 9/27/24.
//

import SwiftUI

struct TabView_WithMe: View {
    @StateObject private var user_ViewModel = User_ViewModel()
    var userId: String
    
    var body: some View {
        TabView{
            User_HomePage().tabItem{ Image(systemName: "house") }
            User_Search().tabItem{ Image(systemName: "magnifyingglass") }
            User_AddPostPage().tabItem{ Image(systemName: "plus") }
            if user_ViewModel.user != nil {
                User_ProfilePage(userId: userId)
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
                user_ViewModel.fetchUser(userId: userId)
            }.navigationBarBackButtonHidden(true)
    }
}

//#Preview {
//    TabView_WithMe(userId: userId)
//}
