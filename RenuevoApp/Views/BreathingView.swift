import SwiftUI

private enum BreathPhase: CaseIterable {
    case inhale, hold, exhale

    var label: String {
        switch self {
        case .inhale: return "Inhala"
        case .hold: return "Sostén"
        case .exhale: return "Exhala"
        }
    }

    var seconds: Double {
        switch self {
        case .inhale: return 4
        case .hold: return 4
        case .exhale: return 6
        }
    }

    var scale: CGFloat {
        switch self {
        case .inhale: return 1.0
        case .hold: return 1.0
        case .exhale: return 0.55
        }
    }
}

/// A guided 4-4-6 breathing exercise: an animated circle expands on inhale,
/// pauses on hold, and contracts on exhale — the same pattern the app already
/// recommends as text in "Ejercicios para calmarte".
struct BreathingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var phase: BreathPhase = .exhale
    @State private var cycles = 0
    @State private var isRunning = false
    @State private var timer: Timer?

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Text(isRunning ? phase.label : "Ejercicio de respiración")
                .font(.title2.bold())

            ZStack {
                Circle()
                    .fill(Color.renuevoAccent.opacity(0.15))
                    .frame(width: 220, height: 220)
                Circle()
                    .fill(Color.renuevoAccent.opacity(0.35))
                    .frame(width: 220, height: 220)
                    .scaleEffect(phase.scale)
                    .animation(.easeInOut(duration: phase.seconds), value: phase)
                Text(isRunning ? "\(Int(phase.seconds))" : "4-4-6")
                    .font(.system(size: 34, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.renuevoAccent)
            }

            if isRunning {
                Text("Ciclo \(cycles + 1)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                Text("Inhala 4 segundos, sostén 4, exhala 6. Repite el ciclo mientras lo necesites.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            Spacer()

            Button {
                isRunning ? stop() : start()
            } label: {
                Label(isRunning ? "Detener" : "Empezar", systemImage: isRunning ? "stop.fill" : "play.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.renuevoAccent)
            .padding(.horizontal)
            .padding(.bottom, 24)
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cerrar") {
                    stop()
                    dismiss()
                }
            }
        }
        .onDisappear { stop() }
    }

    private func start() {
        isRunning = true
        cycles = 0
        phase = .inhale
        scheduleNext()
    }

    private func stop() {
        isRunning = false
        timer?.invalidate()
        timer = nil
        phase = .exhale
    }

    private func scheduleNext() {
        timer = Timer.scheduledTimer(withTimeInterval: phase.seconds, repeats: false) { _ in
            advance()
        }
    }

    private func advance() {
        guard isRunning else { return }
        switch phase {
        case .inhale: phase = .hold
        case .hold: phase = .exhale
        case .exhale:
            cycles += 1
            phase = .inhale
        }
        scheduleNext()
    }
}

#Preview {
    NavigationStack { BreathingView() }
}
