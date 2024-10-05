import SwiftUI
import Firebase
import FirebaseAuth

@main
struct WithMe_iOSApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                   
                    Auth.auth().signIn(withEmail: "muthu@gmail.com", password: "654321") { authResult, error in
                        if let error = error {
                            print("Error logging in: \(error.localizedDescription)")
                        } else {
                            print("Successfully logged in as muthu!")
                        }
                    }
                }
        }
    }
}
