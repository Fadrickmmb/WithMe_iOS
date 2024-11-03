//
//  DeleteDialog.swift
//  WithMe_iOS
//
//  Created by user264550 on 11/3/24.
//

import SwiftUI

struct DeletePostDialog: View {
    let buttonTitle: String
    let action: (String) -> ()
    var userId: String
    var postId: String
    @Binding var isShowing: Bool
    @State private var navigateToEditPost = false

    var body: some View {
        ZStack{
            Spacer()
            VStack {
                HStack(spacing: 40) {
                    VStack {
                        Button(action: {
                            action("delete")
                            isShowing = false
                        }) {
                            Image(systemName: "trash")
                                .resizable()
                                .frame(width: 60, height: 60)
                        }
                        Text("DELETE")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.black)
                    }
                }
                .padding(.bottom, 30)
            }
            .frame(width: 250)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
            ).padding()
        }.padding()
        .overlay{
            VStack{
                HStack{
                    Spacer()
                    Button(action: {
                        isShowing = false
                    }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding(20)
                    }                }
                Spacer()
            }
        }.navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
    }
}
