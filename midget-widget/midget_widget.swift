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
import SkeletonUI

class EntryCache {
    var previousEntry: SimpleEntry?
}

struct Provider: TimelineProvider {
    private let entryCache = EntryCache()

    private func startTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            MediaRemoteController.shared.getCurrentMediaInfo { mediaInfo in
                if let mediaInfo = mediaInfo,
                   let previousMediaInfo = self.entryCache.previousEntry?.mediaInfo {
                    if (
                        mediaInfo.title != previousMediaInfo.title
                        || mediaInfo.artist != previousMediaInfo.artist
                        || mediaInfo.playbackRate != previousMediaInfo.playbackRate
                    ) {
                        WidgetCenter.shared.reloadTimelines(ofKind: "midget_widget")
                    }
                } else {
                    WidgetCenter.shared.reloadTimelines(ofKind: "midget_widget")
                }
            }
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
            self.entryCache.previousEntry = entry
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
    
    var mainControlIconName: String = "play.fill"
    var foregroundColor: NSColor = NSColor.windowFrameTextColor
    
    var mainControlIntent: ControlMediaIntent
    var previousControlIntent: ControlMediaIntent
    var nextControlIntent: ControlMediaIntent
    var openAppIntent: ControlMediaIntent
    
    init(entry: Provider.Entry) {
        self.entry = entry
        
        mainControlIntent = ControlMediaIntent()
        mainControlIntent.command = .play
        
        previousControlIntent = ControlMediaIntent()
        previousControlIntent.command = .previousTrack
        
        nextControlIntent = ControlMediaIntent()
        nextControlIntent.command = .nextTrack

        openAppIntent = ControlMediaIntent()
        openAppIntent.command = ._custom_openApp
        
        if let mediaInfo = entry.mediaInfo {
            if mediaInfo.playbackRate == 0 || mediaInfo.playbackRate == nil {
                self.mainControlIconName = "play.fill"
                mainControlIntent.command = .play
            } else {
                self.mainControlIconName = "pause.fill"
                mainControlIntent.command = .pause
            }
        }
        
        if let artworkColor = entry.mediaInfo?.artworkColor {
            foregroundColor = findForegroundColor(artworkColor: artworkColor) ?? foregroundColor
        }
    }

    var body: some View {
        Button(intent: openAppIntent) {
            HStack(spacing: 0) {
                if let artworkData = entry.mediaInfo?.artworkData,
                   let image = NSImage(data: artworkData) {
                    Image(nsImage: image)
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .cornerRadius(12)
                        .aspectRatio(contentMode: .fit)
                        .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 0))
                }
                
                VStack(spacing: 12) {
                    VStack {
                        if (entry.mediaInfo?.title != nil && entry.mediaInfo?.title != "") {
                            Text(entry.mediaInfo?.title)
                                .font(.system(size: 14, weight: .medium))
                                .skeleton(with: entry.mediaInfo?.title == nil,
                                          size: CGSize(width: 152, height: 14),
                                          lines: 1)
                        }
                        
                        if (entry.mediaInfo?.artist != nil && entry.mediaInfo?.artist != "") {
                            Text(entry.mediaInfo?.artist ?? "")
                                .font(.system(size: 14, weight: .regular))
                                .opacity(0.5)
                                .skeleton(with: entry.mediaInfo?.title == nil,
                                          size: CGSize(width: 96, height: 14),
                                          lines: 1)
                        }
                    }
                    
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
                    .disabled(entry.mediaInfo?.title == nil)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .foregroundColor(Color(nsColor: foregroundColor))
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var findForegroundColorCache = [NSColor: NSColor]()
    
    mutating func findForegroundColor(artworkColor: NSColor) -> NSColor? {
        if let value = findForegroundColorCache[artworkColor] {
            return value
        }
        
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

        findForegroundColorCache[artworkColor] = bestShade

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
                    .background(Color(entry.mediaInfo?.artworkColor ?? NSColor.tertiarySystemFill))
            }
        }
        .configurationDisplayName("Midget")
        .description("A widget to control the media.")
        .contentMarginsDisabled()
        .supportedFamilies([.systemMedium])
    }
}
