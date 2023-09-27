//
//  midget_widget.swift
//  midget-widget
//
//  Created by Arthur Fontaine on 26/09/2023.
//

import WidgetKit
import SwiftUI
import Foundation
import AppIntents

struct Provider: TimelineProvider {
    private func startTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
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

    var body: some View {
        VStack {
            Text("Music: \(entry.mediaInfo?.title ?? "No Music")")
            Button(intent: PauseIntent()) {
                Text("Pause")
            }
        }
    }
}

struct midget_widget: Widget {
    let kind: String = "midget_widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(macOS 14.0, *) {
                midget_widgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                midget_widgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}
