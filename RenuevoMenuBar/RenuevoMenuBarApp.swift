import SwiftUI

@main
struct RenuevoMenuBarApp: App {
    var body: some Scene {
        MenuBarExtra("Renuevo", systemImage: "sun.max.fill") {
            MenuBarContentView()
        }
        .menuBarExtraStyle(.window)
    }
}

struct MenuBarContentView: View {
    private var quote: Quote { QuoteLibrary.quote(for: Date()) }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image("SunMark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                Text("Renuevo")
                    .font(.headline)
                Spacer()
                Text(Date(), style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Label(quote.category.rawValue, systemImage: quote.category.symbol)
                .font(.caption.bold())
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(quote.category.tint.opacity(0.15))
                .foregroundStyle(quote.category.tint)
                .clipShape(Capsule())

            Text(quote.text)
                .font(.system(size: 15, weight: .medium))
                .fixedSize(horizontal: false, vertical: true)

            Text(quote.reference)
                .font(.caption)
                .foregroundStyle(.secondary)

            Divider()

            HStack {
                Button("Abrir Renuevo") {
                    openMainApp()
                }
                Spacer()
                Button("Salir") {
                    NSApplication.shared.terminate(nil)
                }
            }
            .font(.caption)
        }
        .padding(16)
        .frame(width: 280)
    }

    private func openMainApp() {
        guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.renuevo.app") else { return }
        NSWorkspace.shared.open(url)
    }
}
