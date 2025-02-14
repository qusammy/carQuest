
//packages to download
//https://github.com/firebase/firebase-ios-sdk.git
//https://github.com/google/GoogleSignIn-iOS.git
//https://github.com/SDWebImage/SDWebImageSwiftUI.git
//  carQuestApp.swift
//  carQuest
//
//  Created by Maddy Quinn on 8/19/24.
//  Additions by James Hollander

import SwiftUI
import Firebase

@main
struct carQuestApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
    
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil)-> Bool {
        FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        print("Confirgured Firebase.")

        return true
    }
}
