//
//  LifeProgressWidget.swift
//  LifeProgressWidget
//
//  Created by yuki on R 7/04/06.
//

import WidgetKit
import SwiftUI

struct LifeProgressEntry: TimelineEntry{
    let date: Date
    let lifeProgress: Double
    let todayProgress: Double
}

struct LifeProgressProvider: TimelineProvider {
    func placeholder(in context: Context) -> LifeProgressEntry {
        LifeProgressEntry(
            date: Date(),
            lifeProgress: 0.5,
            todayProgress: 0.4
            
        )
    }
    
    func getSnapshot(
        in context: Context,
        completion: @escaping (LifeProgressEntry) -> Void
    ) {
        let entry = makeEntry()
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<LifeProgressEntry>) -> Void) {
        let entry = makeEntry()
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 5, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
    
    private func makeEntry() -> LifeProgressEntry {
        let now = Date()
        let sharedDefaults = UserDefaults(suiteName: "group.TanakaYuki.ScreenTimeReducer.progress")
        let formatter = ISO8601DateFormatter()
        let birthDate = formatter.date(from: sharedDefaults?.string(
            forKey: "birthDate"
        ) ?? "") ?? Date()
        let lifeSpan = sharedDefaults?.integer(forKey: "expectedLifeSpan") ?? 80
        let lifeProgress = LifeProgressCalculator.progress(
            from: birthDate,
            lifeSpan: lifeSpan,
            to: now
        )
        let todayProgress = DayProgressCalculator.progress(for: now)
        return LifeProgressEntry(
            date: now,
            lifeProgress: lifeProgress,
            todayProgress: todayProgress
        )
    }
}


struct LifeProgressWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: LifeProgressProvider.Entry
    
    var body: some View {
        switch family {
        case .accessoryCircular:
            Gauge(value: entry.lifeProgress, in: 0...1){
                Text("Life")
            }currentValueLabel: {
                Text("\(entry.lifeProgress * 100)%")
            }
            .gaugeStyle(.accessoryCircular)
        case .accessoryRectangular:
            HStack{
                Spacer()
                Gauge(value: entry.lifeProgress, in: 0...1){
                    Text("Life")
                }currentValueLabel: {
                    Text("\(entry.lifeProgress * 100)%")
                }
                .gaugeStyle(.accessoryCircular)
                Spacer()
                Gauge(value: entry.todayProgress, in: 0...1){
                    Text("Today")
                }currentValueLabel: {
                    Text("\(entry.todayProgress * 100)%")
                }
                .gaugeStyle(.accessoryCircular)
                Spacer()
            }
        default:
            VStack {
                Text("人生の進捗: \(entry.lifeProgress * 100)%")
                ProgressView(value: entry.lifeProgress)
                Text("今日の進捗: \(entry.todayProgress * 100)%")
                ProgressView(value: entry.todayProgress)
            }
        }
    }
}

struct LifeProgressWidget: Widget {
    let kind: String = "LifeProgressWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: LifeProgressProvider()) { entry in
            if #available(iOS 17.0, *) {
                LifeProgressWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                LifeProgressWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("人生の進捗")
        .description("人生の進捗を表示します。")
        .supportedFamilies(supportedFamilies)
    }
    private var supportedFamilies: [WidgetFamily] {
        if #available(iOSApplicationExtension 16.0, *) {
            return [
                .systemSmall,
                .systemMedium,
                .systemLarge,
                .systemExtraLarge,
                .accessoryInline,
                .accessoryCircular,
                .accessoryRectangular
            ]
        }else{
            return [
                .systemSmall,
                .systemMedium,
                .systemLarge
            ]
        }
    }
}

#Preview(as: .systemSmall) {
    LifeProgressWidget()
} timeline: {
    LifeProgressEntry(
        date: Date(),
        lifeProgress: 0.5,
        todayProgress: 0.4
    )
}
