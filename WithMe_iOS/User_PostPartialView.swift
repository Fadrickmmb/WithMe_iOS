//
//  User_PostModel.swift
//  WithMe_iOS
//
//  Created by user264550 on 10/7/24.
//

import SwiftUI


struct User_PostPartialView: View {
    var post: Post

    var body: some View {
        VStack(alignment: .leading) {
            Text(post.name)
                .font(.headline)
            Text(post.location)
                .font(.subheadline)
            Image(systemName: "photo") // Placeholder para imagem do post
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
            Text("Yummys: \(post.yummys)")
            Text("Comments: \(post.commentsNumber)")
        }
        .padding()
    }
}

#Preview {
    UserPostPartialView(post: Post(postId: "1", userId: "1001", name: "John Doe", postImageUrl: "", userPhotoUrl: "", yummys: 5, location: "New York", postDate: "2023-10-01", commentsNumber: 10))
}
