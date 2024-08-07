//
//  midgetApp.swift
//  midget
//
//  Created by Arthur Fontaine on 26/09/2023.
//

import SwiftUI

@main
struct midgetApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(HiddenTitleBarWindowStyle()) // Optional: Customize window style
        .windowResizability(.contentSize) // Optional: Disable window resizing
    }
}
