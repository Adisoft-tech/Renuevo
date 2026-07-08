import SwiftUI
#if canImport(AppKit)
import AppKit
#endif

extension Color {
    /// Adaptive color that flips automatically with light/dark mode
    /// (UIKit on iOS/Mac Catalyst, AppKit on native macOS targets like the menu bar app).
    init(light: Color, dark: Color) {
        #if canImport(UIKit)
        self = Color(UIColor { traits in
            traits.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
        #elseif canImport(AppKit)
        self = Color(NSColor(name: nil) { appearance in
            appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua ? NSColor(dark) : NSColor(light)
        })
        #else
        self = light
        #endif
    }

    /// Brand colors sampled from the Renuevo logo (the sun/spiral isotype).
    static let renuevoTeal = Color(red: 159 / 255, green: 227 / 255, blue: 230 / 255)
    static let renuevoSlate = Color(red: 52 / 255, green: 76 / 255, blue: 75 / 255)

    static let renuevoAccent = Color(light: .renuevoSlate, dark: .renuevoTeal)

    static let renuevoBackground = Color(
        light: Color(red: 0.96, green: 0.99, blue: 0.99),
        dark: Color(red: 0.10, green: 0.14, blue: 0.14)
    )

    static let renuevoInk = Color(
        light: .renuevoSlate,
        dark: .renuevoTeal
    )
}

extension QuoteCategory {
    var tint: Color {
        switch self {
        case .fe: return .renuevoAccent
        case .superacion: return .orange
        case .crecimiento: return .green
        case .gratitud: return .pink
        }
    }
}
