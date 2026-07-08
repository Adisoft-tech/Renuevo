import AppIntents
import Foundation

/// Lets Siri/Shortcuts surface today's Renuevo message without opening the app,
/// e.g. "Oye Siri, dame mi mensaje de Renuevo".
struct TodayVerseIntent: AppIntent {
    static var title: LocalizedStringResource = "Mensaje del día de Renuevo"
    static var description = IntentDescription("Obtiene el mensaje de fe y crecimiento personal de hoy en Renuevo.")

    func perform() async throws -> some IntentResult & ReturnsValue<String> & ProvidesDialog {
        let quote = QuoteLibrary.quote(for: Date())
        let message = "\(quote.text) — \(quote.reference)"
        return .result(value: message, dialog: IntentDialog(stringLiteral: message))
    }
}

struct RenuevoShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: TodayVerseIntent(),
            phrases: [
                "Dame mi mensaje de \(.applicationName)",
                "Cuál es mi mensaje de \(.applicationName) de hoy",
                "Abre mi reflexión de \(.applicationName)",
            ],
            shortTitle: "Mensaje de hoy",
            systemImageName: "sun.max.fill"
        )
    }
}
