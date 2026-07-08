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
}
