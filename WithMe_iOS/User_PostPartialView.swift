//
//  User_PostModel.swift
//  WithMe_iOS
//
//  Created by user264550 on 10/7/24.
//

import SwiftUI

struct User_PostPartialView: View {
    var postId: String
    var userId: String
    var name: String
    var postImageUrl: String
    var userPhotoUrl: String
    var postDate: String
    var yummys: Int
    var comments: Int
    var location: String

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let url = URL(string: userPhotoUrl), !userPhotoUrl.isEmpty {
                    AsyncImage(url: url) { image in
                        image.resizable()
                             .aspectRatio(contentMode: .fill)
                             .frame(width: 50, height: 50)
                             .clipShape(Circle())
                    } placeholder: {
                        Image(systemName: "person.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }
                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                }

                VStack(alignment: .leading) {
                    Text(name)
                        .font(.custom("DMSerifDisplay-Regular", size: 20))
                    HStack {
                        Image(systemName: "location.fill")
                            .font(.system(size: 16))
                        Text(location)
                    }
                }
                Spacer()
                HStack(spacing: 5) {
                    Circle().frame(width: 7, height: 7)
                    Circle().frame(width: 7, height: 7)
                    Circle().frame(width: 7, height: 7)
                }
            }
            .padding(.vertical)

            if let imageUrl = URL(string: postImageUrl), !postImageUrl.isEmpty {
                AsyncImage(url: imageUrl) { image in
                    image.resizable()
                         .aspectRatio(contentMode: .fill)
                         .frame(maxHeight: 250)
                         .clipped()
                } placeholder: {
                    Image(systemName: "camera")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                }
            } else {
                Image(systemName: "camera")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
            }

            HStack {
                HStack {
                    Image("withme_yummy")
                        .resizable()
                        .frame(width: 25, height: 25)
                    Text("\(yummys)")
                        .font(.system(size: 12))
                }

                Spacer()

                HStack {
                    Image("withme_comment")
                        .resizable()
                        .frame(width: 25, height: 25)
                    Text("\(comments)")
                        .font(.system(size: 12))
                }

                Spacer()

                Text(postDate)
                    .font(.system(size: 12))
            }
            .padding(.vertical)
        }
        .padding()
    }
}
