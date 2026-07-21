import Foundation
import UserNotifications

enum ReminderKind: String, CaseIterable {
    case dailyMessage
    case morningJournal
    case eveningJournal

    var idPrefix: String { "renuevo.reminder.\(rawValue)." }

    var defaultHour: Int {
        switch self {
        case .dailyMessage: return 8
        case .morningJournal: return 8
        case .eveningJournal: return 21
        }
    }

    var defaultMinute: Int {
        switch self {
        case .dailyMessage: return 0
        case .morningJournal: return 30
        case .eveningJournal: return 0
        }
    }

    var displayName: String {
        switch self {
        case .dailyMessage: return "Mensaje del día"
        case .morningJournal: return "Pregunta de la mañana"
        case .eveningJournal: return "Reflexión de la noche"
        }
    }

    func content(for date: Date) -> (title: String, body: String) {
        let quote = QuoteLibrary.quote(for: date)
        switch self {
        case .dailyMessage:
            return ("🙏 Tu mensaje de hoy", "\(quote.text) — \(quote.reference)")
        case .morningJournal:
            return (
                "☀️ Pregunta para hoy",
                "\(quote.question) Ponlo en práctica durante el día y escríbelo esta noche en tu diario."
            )
        case .eveningJournal:
            return (
                "🌙 Cierra tu día",
                "Tres aprendizajes de hoy, qué hiciste bien y en qué puedes mejorar mañana. Escríbelo en tu diario."
            )
        }
    }
}

/// Schedules one local notification per day per reminder kind (not a single repeating
/// notification), because a repeating trigger can't change its message every day. We
/// keep a rolling window of `daysAhead` days queued at all times, for each kind.
final class NotificationManager {
    static let shared = NotificationManager()

    // iOS caps an app at 64 pending local notifications total — anything past
    // that gets silently dropped. With 3 reminder kinds, 14 days keeps us at
    // 42 max, far under the cap (and refreshSchedule() re-tops this window
    // every time the app is foregrounded, so 14 days ahead is always enough).
    private let daysAhead = 14

    private func key(_ suffix: String, for kind: ReminderKind) -> String {
        "renuevo.notif.\(kind.rawValue).\(suffix)"
    }

    func hour(for kind: ReminderKind) -> Int {
        UserDefaults.standard.object(forKey: key("hour", for: kind)) as? Int ?? kind.defaultHour
    }

    func setHour(_ hour: Int, for kind: ReminderKind) {
        UserDefaults.standard.set(hour, forKey: key("hour", for: kind))
        refreshSchedule()
    }

    func minute(for kind: ReminderKind) -> Int {
        UserDefaults.standard.object(forKey: key("minute", for: kind)) as? Int ?? kind.defaultMinute
    }

    func setMinute(_ minute: Int, for kind: ReminderKind) {
        UserDefaults.standard.set(minute, forKey: key("minute", for: kind))
        refreshSchedule()
    }

    func isEnabled(for kind: ReminderKind) -> Bool {
        UserDefaults.standard.object(forKey: key("enabled", for: kind)) as? Bool ?? true
    }

    func setEnabled(_ enabled: Bool, for kind: ReminderKind) {
        UserDefaults.standard.set(enabled, forKey: key("enabled", for: kind))
        refreshSchedule()
    }

    func requestAuthorizationIfNeeded(completion: (() -> Void)? = nil) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                center.requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in
                    DispatchQueue.main.async {
                        self.refreshSchedule()
                        completion?()
                    }
                }
            case .authorized, .provisional:
                DispatchQueue.main.async {
                    self.refreshSchedule()
                    completion?()
                }
            default:
                DispatchQueue.main.async { completion?() }
            }
        }
    }

    /// Clears any previously queued notifications for every reminder kind and re-queues
    /// the next `daysAhead` days at each kind's configured time. Call this on launch,
    /// when the app becomes active, and whenever the user changes a reminder's settings.
    func refreshSchedule() {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { requests in
            let idsToRemove = requests
                .map(\.identifier)
                .filter { identifier in ReminderKind.allCases.contains { identifier.hasPrefix($0.idPrefix) } }
            center.removePendingNotificationRequests(withIdentifiers: idsToRemove)

            let calendar = Calendar.current
            // Interleaved by day (not grouped by kind): if we ever got close to
            // iOS's pending-notification cap again, this way the nearest days
            // keep every reminder kind instead of one kind eating the whole
            // budget and silently starving the others.
            for offset in 0..<self.daysAhead {
                guard let day = calendar.date(byAdding: .day, value: offset, to: Date()) else { continue }
                for kind in ReminderKind.allCases {
                    guard self.isEnabled(for: kind) else { continue }
                    let hour = self.hour(for: kind)
                    let minute = self.minute(for: kind)

                    guard let fireDate = calendar.date(
                        bySettingHour: hour, minute: minute, second: 0, of: day
                    ), fireDate > Date() else { continue }

                    let (title, body) = kind.content(for: day)
                    let content = UNMutableNotificationContent()
                    content.title = title
                    content.body = body
                    content.sound = .default

                    let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: fireDate)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                    let identifier = kind.idPrefix + calendar.startOfDay(for: day).ISO8601Format()
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                    center.add(request)
                }
            }
        }
    }
}
