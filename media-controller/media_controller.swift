//
//  media_controller.swift
//  media-controller
//
//  Created by Arthur Fontaine on 27/09/2023.
//

import AppIntents

struct media_controller: AppIntent {
    static var title: LocalizedStringResource = "media-controller"
    
    func perform() async throws -> some IntentResult {
        print("INTENT")

//        MediaRemoteController.shared.controlMedia(command: .pause)
        return .result()
    }
}
