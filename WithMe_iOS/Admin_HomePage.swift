//
//  Admin_HomePage.swift
//  WithMe_iOS
//
//  Created by Fadrick Barroso on 2024-10-06.
//

import SwiftUI

struct Admin_HomePage: View {
    var body: some View {
        VStack{
            Text("Admin Home Page")
            NavigationLink(
                destination: Admin_SearchPage()){
                    Text("To Search")
                        .font(.system(size: 16))
                        .padding(.top, 10)
            }
                .navigationBarBackButtonHidden(true)
            
            NavigationLink(
                destination: Admin_CreateUser()){
                    Text("Create User")
                        .font(.system(size: 16))
                        .padding(.top, 10)
                }
                .navigationBarBackButtonHidden(true)
            
        }
        
        
    }
}

#Preview {
    Admin_HomePage()
}
