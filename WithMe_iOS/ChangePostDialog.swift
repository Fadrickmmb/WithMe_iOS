//
//  ChangePostDialog.swift
//  WithMe_iOS
//
//  Created by user264550 on 10/14/24.
//
import SwiftUI

struct ChangePostDialog: View {
    let buttonTitle: String
    let action: (String) -> ()
    @Binding var isShowing: Bool

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
                    
                    VStack {
                        Button(action: {
                            action("edit")
                            isShowing = false
                        }) {
                            Image(systemName: "square.and.pencil")
                                .resizable()
                                .frame(width: 55, height: 55)
                        }
                        Text("EDIT")
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
        }
    }
}

