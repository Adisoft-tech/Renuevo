import SwiftUI

struct DiarioView: View {
    private enum Segment: String, CaseIterable {
        case diario = "Diario"
        case oracion = "Oración"
    }

    @State private var segment: Segment = .diario

    var body: some View {
        NavigationStack {
            Group {
                switch segment {
                case .diario: JournalView()
                case .oracion: PrayerListView()
                }
            }
            .navigationTitle(segment.rawValue)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker("Sección", selection: $segment) {
                        ForEach(Segment.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 200)
                }
            }
        }
    }
}

#Preview {
    DiarioView()
}
