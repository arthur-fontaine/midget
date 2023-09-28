//
//  ControlMediaIntent.swift
//  midget-widgetExtension
//
//  Created by Arthur Fontaine on 27/09/2023.
//

import AppIntents
import WidgetKit

struct ControlMediaIntent: AppIntent {
    static var title: LocalizedStringResource = "Control media."
    
    @Parameter(title: "Command")
    var command: MediaRemoteController.MRCommand
    
    func perform() async throws -> some IntentResult {
        MediaRemoteController.shared.controlMedia(command: command)
        return .result()
    }
}
