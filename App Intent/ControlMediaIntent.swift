//
//  ControlMediaIntent.swift
//  midget-widgetExtension
//
//  Created by Arthur Fontaine on 27/09/2023.
//

import AppIntents
import WidgetKit
import AppKit

struct ControlMediaIntent: AppIntent {
    static var title: LocalizedStringResource = "Control media."
    
    @Parameter(title: "Command")
    var command: MediaRemoteController.MRCommand
    
    func perform() async throws -> some IntentResult {
        if (command == ._custom_openApp) {
            MediaRemoteController.shared.getCurrentMediaClient { mediaClient in
                if let mediaClient = mediaClient,
                   let bundleIdentifier = mediaClient.bundleIdentifier {
                    guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleIdentifier) else {
                        return
                    }
                    NSWorkspace.shared.openApplication(at: url, configuration: NSWorkspace.OpenConfiguration())
                }
            }
        }
        
        MediaRemoteController.shared.controlMedia(command: command)
        return .result()
    }
}
