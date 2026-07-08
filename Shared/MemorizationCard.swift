import Foundation

/// Simple Leitner-style spaced repetition: each card lives in a "box" (0-5),
/// correct reviews push it to a higher box with a longer interval before it's
/// due again; a miss sends it back to box 0.
struct MemorizationCard: Identifiable, Codable, Hashable {
    var id: Int
    var box: Int = 0
    var nextReviewDate: Date = Date()
    var addedAt: Date = Date()
    var reviewCount: Int = 0

    var isDue: Bool { nextReviewDate <= Date() }
}

enum Memorization {
    static let boxIntervalDays = [0, 1, 2, 4, 7, 14, 30]

    static func review(_ card: MemorizationCard, correct: Bool) -> MemorizationCard {
        var updated = card
        updated.reviewCount += 1
        updated.box = correct ? min(card.box + 1, boxIntervalDays.count - 1) : 0
        let interval = boxIntervalDays[updated.box]
        updated.nextReviewDate = Date().addingDays(interval)
        return updated
    }
}
