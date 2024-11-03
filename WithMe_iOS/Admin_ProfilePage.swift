//
//  Admin_ProfilePage.swift
//  WithMe_iOS
//
//  Created by Fadrick Barroso on 2024-11-02.
//

import SwiftUI

struct Admin_ProfilePage: View {
    var body: some View {
        NavigationLink(destination: Admin_Dashboard()) {
            Text("To Dashboard")
                .font(.system(size: 16))
            
        }
    }
}

#Preview {
    Admin_ProfilePage()
}
