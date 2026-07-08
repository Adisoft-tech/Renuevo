import SwiftUI

@main
struct RenuevoWatchApp: App {
    var body: some Scene {
        WindowGroup {
            WatchTodayView()
        }
    }
}

struct WatchTodayView: View {
    @State private var showingBreathing = false
    private var quote: Quote { QuoteLibrary.quote(for: Date()) }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Label(quote.category.rawValue, systemImage: quote.category.symbol)
                        .font(.caption2.bold())
                        .foregroundStyle(quote.category.tint)

                    Text(quote.text)
                        .font(.system(.body, design: .rounded).weight(.semibold))

                    Text(quote.reference)
                        .font(.caption2)
                        .foregroundStyle(.secondary)

                    Text(quote.prayer)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .italic()
                        .padding(.top, 4)

                    Button {
                        showingBreathing = true
                    } label: {
                        Label("Respirar", systemImage: "wind")
                    }
                    .padding(.top, 6)
                }
                .padding(.horizontal, 4)
            }
            .navigationTitle("Renuevo")
        }
        .sheet(isPresented: $showingBreathing) {
            WatchBreathingView()
        }
    }
}

#Preview {
    WatchTodayView()
}
