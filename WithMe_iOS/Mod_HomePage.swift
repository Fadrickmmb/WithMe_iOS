//
//  Mod_HomePage.swift
//  WithMe_iOS
//
//  Created by Fadrick Barroso on 2024-10-29.
//

import SwiftUI

struct Mod_HomePage: View {
    var body: some View {
        VStack{
            Text("Mod Home Page")
            NavigationLink(
                destination: Mod_SearchPage()){
                    Text("To Search")
                        .font(.system(size: 16))
                        .padding(.top, 10)
            }
                .navigationBarBackButtonHidden(true)
            
            
        }
    }
}

#Preview {
    Mod_HomePage()
}
