import WidgetKit
import SwiftUI

// MARK: - Widget Entry
struct MindsetWidgetEntry: TimelineEntry {
    let date: Date
    let quote: String
}

// MARK: - Timeline Provider
struct MindsetWidgetTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> MindsetWidgetEntry {
        MindsetWidgetEntry(date: Date(), quote: "BE YOURSELF. THE WORLD WILL ADJUST.")
    }

    func getSnapshot(in context: Context, completion: @escaping (MindsetWidgetEntry) -> ()) {
        let defaults = UserDefaults(suiteName: "group.com.example.mindset_app")
        let quote = defaults?.string(forKey: "mindset_quote") ?? "BE YOURSELF. THE WORLD WILL ADJUST."
        let entry = MindsetWidgetEntry(date: Date(), quote: quote)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MindsetWidgetEntry>) -> ()) {
        var entries: [MindsetWidgetEntry] = []
        
        let defaults = UserDefaults(suiteName: "group.com.example.mindset_app")
        let quote = defaults?.string(forKey: "mindset_quote") ?? "BE YOURSELF. THE WORLD WILL ADJUST."
        
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = MindsetWidgetEntry(date: entryDate, quote: quote)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

// MARK: - Widget View
struct MindsetWidgetEntryView: View {
    var entry: MindsetWidgetTimelineProvider.Entry

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Image(systemName: "sparkles")
                    .font(.system(size: 28))
                    .foregroundColor(.orange)

                Text(entry.quote)
                    .font(.system(size: 16, weight: .semibold, design: .default))
                    .italic()
                    .foregroundColor(.white)
                    .lineLimit(5)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .padding()
        }
    }
}

// MARK: - Widget Definition
struct MindsetWidget: Widget {
    let kind: String = "MindsetWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: MindsetWidgetTimelineProvider()
        ) { entry in
            MindsetWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Mindset")
        .description("Display inspirational quotes")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Preview
#Preview(as: .systemSmall) {
    MindsetWidget()
} timeline: {
    MindsetWidgetEntry(date: .now, quote: "BE YOURSELF. THE WORLD WILL ADJUST.")
}
