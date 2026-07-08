import SwiftUI

struct MetasView: View {
    private enum Segment: String, CaseIterable {
        case metas = "Metas"
        case habitos = "Hábitos"
    }

    @State private var segment: Segment = .metas

    var body: some View {
        NavigationStack {
            Group {
                switch segment {
                case .metas: GoalsView()
                case .habitos: HabitsView()
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
    MetasView()
}
