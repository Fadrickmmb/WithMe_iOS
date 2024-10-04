//
//  User_ProfilePage.swift
//  WithMe_iOS
//
//  Created by user264550 on 9/27/24.
//

import SwiftUI

struct User_ProfilePage: View {
    @State private var name = ""

    var body: some View {
        ZStack(alignment: .top){
            ScrollView{
                VStack{
                    
                    HStack{
                        Image("withme_logo").resizable().aspectRatio(contentMode: .fit).frame(height: 70)
                        Spacer()
                        Image("withme_yummy").resizable().aspectRatio(contentMode: .fit).frame(width: 30,height: 30)
                        Image("withme_comment").resizable().aspectRatio(contentMode: .fit).frame(width: 30,height: 30)
                    }.padding()
                    
                    HStack{
                        Image("withme_logo").resizable().frame(width:180,height:180).aspectRatio(contentMode:.fit).clipShape(Circle())
                    }.padding()
                    
                    Text("YOUR NAME" + name).font(.custom("DMSerifDisplay-Regular",size: 26)).padding()
                    
                    HStack{
                        VStack{
                            Text("Number").font(.custom("DMSerifDisplay-Regular", size: 22))
                            Text("Followers").font(.system(size: 16))
                        }.padding()
                        VStack{
                            Text("Number").font(.custom("DMSerifDisplay-Regular", size: 22))
                            Text("Posts").font(.system(size: 16))
                        }.padding()
                        VStack{
                            Text("Number").font(.custom("DMSerifDisplay-Regular", size: 22))
                            Text("Yummys").font(.system(size: 16))
                        }.padding()
                    }
                    
                    Text("BIO" + name).font(.custom("DMSerifDisplay-Regular",size: 26)).padding()
                    
                    Text("Your bio here" + name).font(.custom("DMSerifDisplay-Regular",size: 20)).padding()
                                        
                    Button {
                        
                    } label: {
                        Text("Edit Profile")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .bold()
                            .frame(maxWidth: 120, maxHeight: 20)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(Color.black)
                            ).padding(.horizontal)
                    }
                    
                    
                }.padding(.top,0)
            }
        }
    }
}

#Preview {
    User_ProfilePage()
}
