//
//  User_Search.swift
//  WithMe_iOS
//
//  Created by Fadrick Barroso on 2024-10-07.
//

import SwiftUI
import Firebase

struct User_Search: View {
    @State private var search: String = ""
    @State private var userName: String = "No user found"
    
    var body: some View {
        VStack{
            HStack{
                Image("withme_logo")
                    .resizable()
                    .frame(width: 50, height: 18)
                    .padding(20)
                Image("withme_yummy")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding(10)
                Image("withme_comment")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding(10)
                Spacer()
            }
            
            HStack{
                Text("Search")
            }
            
            HStack{
                TextField("Enter name to search", text: $search)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding(.horizontal, 50)
                    .padding(.vertical, 10)
                    .cornerRadius(5)
            }
            
            HStack {
                Button(action: {
                    searchUser()
                }) {
                    Text("Search User")
                        .font(.system(size: 16))
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
            }
            .padding(.top, 10)
            
            HStack {
                Text(userName)
                    .font(.system(size: 18))
                    .padding(.top, 10)
            }
            
            HStack{
                NavigationLink(destination: User_HomePage()) {
                    Text("Back to Home Screen")
                        .font(.system(size: 16))
                        .padding(.top, 10)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    
    func searchUser() {
        guard search.count >= 5 else {
            userName = "Please enter at least 5 characters"
            return
        }
        
        let searchKey = String(search.prefix(5)).lowercased()
        
        let ref = Database.database().reference().child("users")
        
        ref.observeSingleEvent(of: .value) { snapshot in
            if let usersDict = snapshot.value as? [String: AnyObject] {
                for user in usersDict {
                    if let name = user.value["name"] as? String {
                        if name.lowercased().hasPrefix(searchKey) {
                            userName = name
                            return
                        }
                    }
                }
                userName = "We haven't found an user that matches '\(searchKey)'"
            } else {
                userName = "No user data available"
            }
        }
    }
}

#Preview {
    User_Search()
}
