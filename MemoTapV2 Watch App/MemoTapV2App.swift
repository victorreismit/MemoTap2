//
//  MemoTapV2App.swift
//  MemoTapV2 Watch App
//
//  Created by Victor Reis on 11/08/2024.
//

import SwiftUI // Import the SwiftUI framework

// Define the main application struct
@main
struct MemoTapV2App: App {
    // Body property that defines the main scene for the app
    var body: some Scene {
        WindowGroup {
            NavigationView { // Create a navigation view for the app
                GameMenuView() // Set the GameMenuView as the initial screen
            }
        }
    }
}
