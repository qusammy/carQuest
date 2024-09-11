//
//  carQuestApp.swift
//  carQuest
//
//  Created by Maddy Quinn on 8/19/24.
//  Additions by James Hollander

import SwiftUI
import Firebase

@main
struct carQuestApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
