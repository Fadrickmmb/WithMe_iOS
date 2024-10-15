//
//  CommentDialog.swift
//  WithMe_iOS
//
//  Created by user264550 on 10/14/24.
//

import SwiftUI

struct CommentDialog: View {
    @Binding var commentText: String
    @Binding var isShowing: Bool
    let buttonTitle: String
    let action: () -> ()

    var body: some View {
        ZStack{
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        isShowing = false
                    }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(20)
                    }
                }
                Spacer()
                Text("Add Comment")
                    .font(.title2)
                    .bold()
                    .padding()

                TextField("Enter your comment", text: $commentText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button {
                    action()
                } label: {
                    Text(buttonTitle)
                        .font(.system(size: 16, weight: .bold))
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20).fill(Color.black))
                        .foregroundColor(.white)
                }
                .padding()
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 20)        }
    }
}
