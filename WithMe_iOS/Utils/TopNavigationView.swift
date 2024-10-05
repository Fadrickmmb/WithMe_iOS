//
//  TopNavigationView.swift
//  WITH ME
//
//  Created by Surya on 23/09/24.
//

import SwiftUI

struct TopNavigationView: View {
    var body: some View {
        HStack {
            Image(systemName: "fork.knife.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            
            Text("WITH ME")
                .font(.headline)
            
            Spacer()
            
            Image(systemName: "heart.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
            
            Image(systemName: "message.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
        }
        .padding(.horizontal)
        .cornerRadius(10)
        
    }
}

