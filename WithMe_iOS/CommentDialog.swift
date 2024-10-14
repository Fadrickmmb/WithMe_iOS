//
//  CommentDialog.swift
//  WithMe_iOS
//
//  Created by user264550 on 10/14/24.
//

import SwiftUI

struct CommentDialog: View{
    let title: String
    let message: String
    let buttonTitle: String
    let action: () -> ()
    
    var body: some View{
        VStack{
            Text(title)
                .font(.title2)
                .bold()
                .padding()
            
            Text(message)
                .font(.body)
            
            Button{
                action()
            } label: {
                RoundedRectangle(cornerRadius: 20)
                
                Text(buttonTitle)
                    .font(.system(size: 16,weight: .bold))
                    .padding()
            }.padding()
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding()
        .background(.white)
        clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 20)
    }
}

struct CommentDialog_Previews: PreviewProvider{
    static var previews: some View{
        CommentDialog(title: "Add comment:",message: "Write your comment", buttonTitle: "Add", action: <#T##() -> Void#>)
    }
}
