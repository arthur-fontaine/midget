//
//  midget_widget.swift
//  midget-widget
//
//  Created by Arthur Fontaine on 26/09/2023.
//

import Foundation
import SwiftUI
import AppKit
import WidgetKit
import AppIntents

struct Provider: TimelineProvider {
    private func startTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // TODO: only reload if the infos have changed
            WidgetCenter.shared.reloadTimelines(ofKind: "midget_widget")
        }
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), mediaInfo: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), mediaInfo: nil)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        startTimer()
        
        // Fetch the current music title here
        MediaRemoteController.shared.getCurrentMediaInfo { mediaInfo in
            let currentDate = Date()
            let entry = SimpleEntry(date: currentDate, mediaInfo: mediaInfo)

            // Create a timeline with the entry
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let mediaInfo: MediaRemoteController.MediaInfo?
}

struct midget_widgetEntryView : View {
    var entry: Provider.Entry
    
    var mainControlIconName: String
    var foregroundColor: NSColor = NSColor.windowFrameTextColor
    
    var mainControlIntent: ControlMediaIntent
    var previousControlIntent: ControlMediaIntent
    var nextControlIntent: ControlMediaIntent
    
    init(entry: Provider.Entry) {
        self.entry = entry
        
        mainControlIntent = ControlMediaIntent()
        if entry.mediaInfo?.playbackRate == 0 || entry.mediaInfo?.playbackRate == nil {
            self.mainControlIconName = "play.fill"
            mainControlIntent.command = .play
        } else {
            self.mainControlIconName = "pause.fill"
            mainControlIntent.command = .pause
        }
        
        previousControlIntent = ControlMediaIntent()
        previousControlIntent.command = .previousTrack
        
        nextControlIntent = ControlMediaIntent()
        nextControlIntent.command = .nextTrack
        
        if let artworkColor = entry.mediaInfo?.artworkColor {
            foregroundColor = findForegroundColor(artworkColor: artworkColor) ?? foregroundColor
        }
    }

    var body: some View {
        VStack {
            Text(entry.mediaInfo?.title ?? "No Music")
                .font(.system(size: 14, weight: .medium))
            Text(entry.mediaInfo?.artist ?? "")
                .font(.system(size: 14, weight: .regular))
                .opacity(0.5)
                .padding(.bottom, 12)
            HStack(spacing: 32) {
                Button(intent: previousControlIntent) {
                    Image(systemName: "backward.fill")
                        .font(.system(size: 20))
                }
                
                Button(intent: mainControlIntent) {
                    Image(systemName: mainControlIconName)
                        .font(.system(size: 32))
                }
                
                Button(intent: nextControlIntent) {
                    Image(systemName: "forward.fill")
                        .font(.system(size: 20))
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .foregroundColor(Color(nsColor: foregroundColor))
    }
    
    func findForegroundColor(artworkColor: NSColor) -> NSColor? {
        let shades = artworkColor.shades

        var maxContrast: CGFloat = 0.0
        var bestShade: NSColor?

        for shade in shades {
            let contrast = shade.contrastRatio(with: artworkColor)

            if shade.hexString != "#000000" && shade.hexString != "#FFFFFF" {
                if contrast > maxContrast {
                    maxContrast = contrast
                    bestShade = shade
                }
            }
        }

        return bestShade
    }
}

struct midget_widget: Widget {
    let kind: String = "midget_widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(macOS 14.0, *) {
                midget_widgetEntryView(entry: entry)
                    .containerBackground(Color(entry.mediaInfo?.artworkColor ?? NSColor.tertiarySystemFill), for: .widget)
            } else {
                midget_widgetEntryView(entry: entry)
                    .padding()
                    .background(Color(entry.mediaInfo?.artworkColor ?? NSColor.tertiarySystemFill))
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}
