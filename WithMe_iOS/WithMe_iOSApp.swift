//
//  WithMe_iOSApp.swift
//  WithMe_iOS
//
//  Created by Fadrick Barroso on 2024-09-22.
//

import SwiftUI
import FirebaseCore
import GoogleMaps

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      GMSServices.provideAPIKey("AIzaSyDswLMkBgDwQrcKRGpkXSqi4ZMWMEYgkQ0")
      FirebaseApp.configure()
    return true
  }
}

@main
struct WithMe_iOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
    }
}

struct SplashScreenView: View {
    @State private var isActive: Bool = false
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            Image("splash_logo")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .ignoresSafeArea()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
        }
    }
}
