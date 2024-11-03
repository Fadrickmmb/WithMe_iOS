//
//  ReportCommentDialog.swift
//  WithMe_iOS
//
//  Created by user264550 on 11/3/24.
//

import SwiftUI

struct ReportCommentDialog: View {
    let buttonTitle: String
    let action: (String) -> ()
    var userId: String
    var postId: String
    @Binding var isShowing: Bool

    var body: some View {
        ZStack{
            Spacer()
            VStack(spacing: 40) {
                Button(action: {
                    action("report")
                    isShowing = false
                }) {
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .frame(width: 55, height: 55)
                }
                Text("REPORT")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.black)
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

