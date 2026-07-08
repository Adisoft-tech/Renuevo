import Foundation

struct PrayerRequest: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var title: String
    var notes: String = ""
    var date: Date = Date()
    var isAnswered: Bool = false
    var answeredDate: Date?
    var answeredNote: String = ""
}
