import Foundation

extension Date {
    /// Stable "yyyy-MM-dd" key in the current calendar, used to compare calendar
    /// days regardless of time-of-day — the basis for streaks, habits and plans.
    var dayKey: String {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return String(format: "%04d-%02d-%02d", components.year ?? 0, components.month ?? 0, components.day ?? 0)
    }

    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

    func addingDays(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }
}
