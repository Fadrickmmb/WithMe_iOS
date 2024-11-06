//
//  Notification.swift
//  WithMe_iOS
//
//  Created by Dhinesh R on 05/11/24.
//

import SwiftUI

import SwiftUI

struct Notification: Identifiable {
    let id = UUID()
    let title: String
    let message: String
}

struct NotificationsView: View {
    @State private var notifications: [Notification] = [
        Notification(title: "New Notification", message: "This is a sample notification message to show how notifications will appear in the list."),
        Notification(title: "New Notification", message: "This is a sample notification message to show how notifications will appear in the list."),
        Notification(title: "New Notification", message: "This is a sample notification message to show how notifications will appear in the list."),
        Notification(title: "New Notification", message: "This is a sample notification message to show how notifications will appear in the list."),
        Notification(title: "New Notification", message: "This is a sample notification message to show how notifications will appear in the list.")
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                List(notifications) { notification in
                    HStack(alignment: .top) {
                        Image(systemName: "bell.fill")
                            .resizable()
                            .foregroundColor(.blue)
                            .frame(width: 30, height: 30)
                            .padding(.trailing, 10)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(notification.title)
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text(notification.message)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(2) // Limit message to two lines
                        }
                    }
                    .padding(.vertical, 5)
                }
                .listStyle(PlainListStyle())
                .navigationBarTitle("Notifications", displayMode: .inline)
                .navigationBarItems(leading: Button(action: {
                    // Action for back button
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.blue)
                })
            }
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
