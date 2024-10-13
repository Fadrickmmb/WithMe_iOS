//
//  User_ViewProfile.swift
//  WithMe_iOS
//
//  Created by Fadrick Barroso on 9/27/24.
//

import SwiftUI

struct User_ViewProfile: View {
    var userName: String
    var userUid: String
    
    var body: some View {
        VStack {
            Text("User Profile")
                .font(.title)
                .padding()
            
            Text("Name: \(userName)")
                .font(.system(size: 18))
                .padding()
            
            Text("UID: \(userUid)")
                .font(.system(size: 18))
                .padding()
            
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    User_ViewProfile(userName: "Test User", userUid: "12345")
}
