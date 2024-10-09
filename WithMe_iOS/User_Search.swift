//
//  User_Search.swift
//  WithMe_iOS
//
//  Created by Fadrick Barroso on 2024-10-07.
//

import SwiftUI

struct User_Search: View {
    @State private var search: String = ""
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
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    User_Search()
}
