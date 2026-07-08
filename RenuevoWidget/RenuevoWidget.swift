import WidgetKit
import SwiftUI

struct QuoteEntry: TimelineEntry {
    let date: Date
    let quote: Quote
}

struct QuoteProvider: TimelineProvider {
    func placeholder(in context: Context) -> QuoteEntry {
        QuoteEntry(date: Date(), quote: QuoteLibrary.all[0])
    }

    func getSnapshot(in context: Context, completion: @escaping (QuoteEntry) -> Void) {
        completion(QuoteEntry(date: Date(), quote: QuoteLibrary.quote(for: Date())))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<QuoteEntry>) -> Void) {
        let calendar = Calendar.current
        var entries: [QuoteEntry] = []

        // One entry per day for the next 7 days so the widget flips automatically
        // at midnight without needing the app to push an update.
        for offset in 0..<7 {
            guard let day = calendar.date(byAdding: .day, value: offset, to: Date()) else { continue }
            let startOfDay = calendar.startOfDay(for: day)
            entries.append(QuoteEntry(date: startOfDay, quote: QuoteLibrary.quote(for: day)))
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct RenuevoWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: QuoteEntry

    var body: some View {
        switch family {
        case .accessoryCircular:
            AccessoryCircularView(entry: entry)
        case .accessoryRectangular:
            AccessoryRectangularView(entry: entry)
        case .accessoryInline:
            Text("🙏 \(entry.quote.text)")
        default:
            HomeScreenView(entry: entry)
        }
    }
}

private struct HomeScreenView: View {
    @Environment(\.widgetFamily) private var family
    let entry: QuoteEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image("SunMark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)

                Text(entry.quote.category.rawValue)
                    .font(.caption2.bold())
                    .foregroundStyle(entry.quote.category.tint)
            }

            Text(entry.quote.text)
                .font(.system(.footnote, design: .rounded).weight(.semibold))
                .foregroundStyle(Color.renuevoInk)
                .lineLimit(family == .systemSmall ? 5 : 4)

            Spacer(minLength: 0)

            Text(entry.quote.reference)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .widgetBackground(Color.renuevoBackground)
    }
}

/// Lock Screen circular widget: just the category glyph, so it stays legible at tiny size.
private struct AccessoryCircularView: View {
    let entry: QuoteEntry

    var body: some View {
        ZStack {
            AccessoryWidgetBackground()
            Image(systemName: entry.quote.category.symbol)
                .font(.title2)
        }
        .widgetBackground(Color.clear)
    }
}

/// Lock Screen rectangular widget: category + a couple of lines of the verse.
private struct AccessoryRectangularView: View {
    let entry: QuoteEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Label(entry.quote.category.rawValue, systemImage: entry.quote.category.symbol)
                .font(.caption2.bold())
            Text(entry.quote.text)
                .font(.caption)
                .lineLimit(3)
            Text(entry.quote.reference)
                .font(.caption2)
        }
        .widgetBackground(Color.clear)
    }
}

extension View {
    /// iOS 17 requires `containerBackground` for widgets; earlier versions use `.background`.
    @ViewBuilder
    func widgetBackground(_ color: Color) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            self.containerBackground(color, for: .widget)
        } else {
            self.background(color)
        }
    }
}

struct RenuevoWidget: Widget {
    let kind: String = "RenuevoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QuoteProvider()) { entry in
            RenuevoWidgetView(entry: entry)
        }
        .configurationDisplayName("Mensaje del día")
        .description("Un mensaje diario de fe, superación y crecimiento personal.")
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryCircular, .accessoryRectangular, .accessoryInline])
    }
}
