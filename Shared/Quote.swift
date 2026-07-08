import Foundation

enum QuoteCategory: String, Codable, CaseIterable {
    case fe = "Fe"
    case superacion = "Superación"
    case crecimiento = "Crecimiento"
    case gratitud = "Gratitud"

    var symbol: String {
        switch self {
        case .fe: return "hands.sparkles.fill"
        case .superacion: return "flame.fill"
        case .crecimiento: return "leaf.fill"
        case .gratitud: return "heart.fill"
        }
    }
}

struct Quote: Identifiable, Codable, Hashable {
    let id: Int
    let text: String
    let reference: String
    let category: QuoteCategory
    /// A 2-3 minute reflection expanding on the verse/phrase.
    let reflection: String
    /// A one-line practical teaching distilled from the reflection.
    let practicalTeaching: String
    /// A question to journal about, specific to this quote.
    let question: String
    /// A concrete, doable action for today.
    let action: String
    /// A short prayer tied to the theme.
    let prayer: String
}
