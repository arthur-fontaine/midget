//
//  ContentView.swift
//  midget
//
//  Created by Arthur Fontaine on 26/09/2023.
//

import SwiftUI

struct ContentView: View {
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    var body: some View {
        VStack {
            Text("Version \(appVersion ?? "")")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
