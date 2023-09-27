//
//  PauseIntent.swift
//  midget-widgetExtension
//
//  Created by Arthur Fontaine on 27/09/2023.
//

import AppIntents

struct PauseIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Pause music."
    static var description = IntentDescription("Pause the music.")
    
    func perform() async throws -> some IntentResult {
        MediaRemoteController.shared.controlMedia(command: .pause)
        return .result()
    }
}
