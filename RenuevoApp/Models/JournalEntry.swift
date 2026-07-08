import Foundation

struct JournalEntry: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var date: Date = Date()
    var mood: String = "🙂"
    var text: String = ""
}

enum MoodOption: String, CaseIterable {
    case grateful = "🙏"
    case happy = "🙂"
    case peaceful = "😌"
    case tired = "😔"
    case anxious = "😟"
    case hopeful = "✨"

    /// A rough 1-5 sense of well-being for each mood, used only to draw a trend
    /// line in the insights dashboard — not a clinical measure of anything.
    var valence: Int {
        switch self {
        case .grateful, .hopeful: return 5
        case .happy, .peaceful: return 4
        case .tired: return 2
        case .anxious: return 1
        }
    }

    var label: String {
        switch self {
        case .grateful: return "Agradecido"
        case .happy: return "Feliz"
        case .peaceful: return "En paz"
        case .tired: return "Cansado"
        case .anxious: return "Ansioso"
        case .hopeful: return "Esperanzado"
        }
    }
}
