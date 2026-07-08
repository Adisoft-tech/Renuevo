import Foundation

struct ChatMessage: Identifiable, Codable {
    var id: UUID = UUID()
    var date: Date = Date()
    var userText: String
    var response: MoodResponse
}
