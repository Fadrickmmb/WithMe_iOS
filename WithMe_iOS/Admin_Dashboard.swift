//
//  Admin_Dashboard.swift
//  WithMe_iOS
//
//  Created by Fadrick Barroso on 2024-11-02.
//

import SwiftUI
import Firebase

struct Admin_Dashboard: View {
    @State private var selectedOption = "Reported Comments"
    let options = ["Reported Comments", "Reported Posts", "Reported Users", "Suspended Users"]
    
    @State private var items: [String] = []
    let database = Database.database().reference()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Admin Dashboard")
                    .font(.largeTitle)
                    .padding()
                
                Picker("Select an option", selection: $selectedOption) {
                    ForEach(options, id: \.self) { option in
                        Text(option)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .onChange(of: selectedOption) { _ in
                    fetchItems()
                }
                
                List(items, id: \.self) { item in
                    if selectedOption == "Reported Users" || selectedOption == "Suspended Users" {
                        NavigationLink(destination: Admin_ViewProfile(userId: item)) {
                            Text(item)
                        }
                    } else {
                        Text(item)
                    }
                }
                .padding()
            }
            .padding()
            .onAppear {
                fetchItems()
            }
        }
    }
    
    private func fetchItems() {
        var tableName = ""
        
        switch selectedOption {
        case "Reported Posts":
            tableName = "reportedPosts"
        case "Reported Comments":
            tableName = "reportedComments"
        case "Reported Users":
            tableName = "reportedUsers"
        case "Suspended Users":
            tableName = "suspendedUsers"
        default:
            return
        }
        
        database.child(tableName).observeSingleEvent(of: .value) { snapshot in
            var fetchedItems: [String] = []
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot {
                    fetchedItems.append(childSnapshot.key)
                }
            }
            items = fetchedItems
        }
    }
}


#Preview {
    Admin_Dashboard()
}
