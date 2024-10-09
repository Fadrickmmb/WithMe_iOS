//
//  User_HomePage.swift
//  WithMe_iOS
//
//  Created by user264550 on 9/27/24.
//

import SwiftUI

struct User_HomePage: View {
    var body: some View {
        VStack{
            Text("Home page")
            
            NavigationLink(destination: User_Search()) {
                Text("Go to Search")
                    .font(.system(size: 16))
                    .padding(.top, 10)
            }
        }
        .navigationBarBackButtonHidden(true)
            
    }
}

#Preview {
    User_HomePage()
}
