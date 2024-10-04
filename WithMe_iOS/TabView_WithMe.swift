//
//  TabView_WithMe.swift
//  WithMe_iOS
//
//  Created by user264550 on 9/27/24.
//

import SwiftUI

struct TabView_WithMe: View {
    var body: some View {
        TabView{
            User_HomePage().tabItem{ Image(systemName: "house") }
            User_SearchPage().tabItem{ Image(systemName: "magnifyingglass") }
            User_AddPostPage().tabItem{ Image(systemName: "plus") }
            User_ProfilePage().tabItem{ Image(systemName: "person") }
            
        }.accentColor(.black)
    }
}

#Preview {
    TabView_WithMe()
}
