import Foundation

struct Habit: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var title: String
    var icon: String = "checkmark.circle.fill"
    var createdAt: Date = Date()
    var completedDayKeys: Set<String> = []
    var isArchived: Bool = false

    func isCompleted(on date: Date = Date()) -> Bool {
        completedDayKeys.contains(date.dayKey)
    }

    /// Consecutive days completed ending today. If today isn't done yet, the streak
    /// still counts through yesterday so it doesn't look broken before the day ends.
    var currentStreak: Int {
        var streak = 0
        var cursor = Date()
        if !completedDayKeys.contains(cursor.dayKey) {
            cursor = cursor.addingDays(-1)
        }
        while completedDayKeys.contains(cursor.dayKey) {
            streak += 1
            cursor = cursor.addingDays(-1)
        }
        return streak
    }
}
