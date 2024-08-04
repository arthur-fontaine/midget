//
//  ContentView.swift
//  midget
//
//  Created by Arthur Fontaine on 26/09/2023.
//

import SwiftUI
import AppKit

struct ContentView: View {
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    var body: some View {
        VStack {
            Image(nsImage: NSImage(named: "AppIcon") ?? NSImage()) // Replace "AppIcon" with the actual name of your app icon asset
                .resizable()
                .frame(width: 100, height: 100) // Adjust the size as needed
            Text("Midget")
                .font(.system(size: 24, weight: .bold))
                .padding(.bottom, 5)
            Text("Version \(appVersion ?? "")")
                .font(.system(size: 14))
                .padding(.bottom, 10)
            Button(action: {
                NSWorkspace.shared.open(URL(string: "https://github.com/arthur-fontaine/midget")!)
            }) {
                Text("View on GitHub")
            }
            .buttonStyle(LinkButtonStyle())
            Button(action: {
                NSWorkspace.shared.open(URL(string: "https://x.com/voithure")!)
            }) {
                Text("Follow me on Twitter/X")
            }
            .buttonStyle(LinkButtonStyle())
            Text("🐐 Arthur Fontaine")
                .font(.system(size: 12))
                .padding(.top, 10)
        }
        .frame(width: 300, height: 300)
    }
}

#Preview {
    ContentView()
}
