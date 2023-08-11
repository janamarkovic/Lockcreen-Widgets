//
//  LockscreenWidgets.swift
//  LockscreenWidgets
//
//  Created by Jana Markovic on 30.11.22..
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct LockscreenWidgetsEntryView: View {
    
    @Environment (\.widgetFamily) var widgetFamily
    var entry: Provider.Entry

    var body: some View {
        
        switch widgetFamily {
        
        case .accessoryCircular:
            Gauge(value: 0.7){
                Text(entry.date, format:.dateTime)
            }
            .gaugeStyle(.accessoryCircular)
        case .accessoryRectangular:
            
            Gauge(value: 0.7){
                Text(entry.date, format:.dateTime)
            }
            .gaugeStyle(.accessoryLinear)
            
        case .accessoryInline:
            VStack {
                Text(entry.date, format: .dateTime)
                Text(entry.configuration.Symbol ?? "No value") 
            }
            
        default: Text("Not implemented")
        }
    }
}

struct LockscreenWidgets: Widget {
    let kind: String = "LockscreenWidgets"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            LockscreenWidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.accessoryInline, .accessoryCircular, .accessoryRectangular])
    }
}

struct LockscreenWidgets_Previews: PreviewProvider {
    static var previews: some View {
        LockscreenWidgetsEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .accessoryInline))
            .previewDisplayName("inline")
        
        LockscreenWidgetsEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
            .previewDisplayName("Circular")
        
        LockscreenWidgetsEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
            .previewDisplayName("Rectangular")
        
    }
}
