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
                TextField("",text: $search)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding(.horizontal, 50)
                    .padding(.vertical, 10)
                    .cornerRadius(5)
            }
            
            HStack {
                Button(action: {
                    getFirstUserName()
                }) {
                    Text("Show First User")
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
    
    //TEST//
    func getFirstUserName() {
        let ref = Database.database().reference().child("users")
        
        ref.queryLimited(toFirst: 1).observeSingleEvent(of: .value) { snapshot in
            if let usersDict = snapshot.value as? [String: AnyObject],
               let firstUser = usersDict.first {
                if let name = firstUser.value["name"] as? String {
                    userName = name
                } else {
                    userName = "No name available"
                }
            } else {
                userName = "No user found"
            }
        }
    }
}

#Preview {
    User_Search()
}
