import SwiftUI
import WatchKit

private enum WatchBreathPhase: CaseIterable {
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
        case .inhale, .hold: return 1.0
        case .exhale: return 0.55
        }
    }
}

/// The same 4-4-6 breathing pattern as the iPhone app's `BreathingView`, adapted
/// for a small watch screen, with a haptic tap on every phase change.
struct WatchBreathingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var phase: WatchBreathPhase = .exhale
    @State private var isRunning = false
    @State private var timer: Timer?

    var body: some View {
        VStack(spacing: 10) {
            Text(isRunning ? phase.label : "Respiración 4-4-6")
                .font(.headline)
                .multilineTextAlignment(.center)

            ZStack {
                Circle()
                    .fill(Color.renuevoAccent.opacity(0.3))
                    .frame(width: 90, height: 90)
                    .scaleEffect(phase.scale)
                    .animation(.easeInOut(duration: phase.seconds), value: phase)
            }
            .frame(height: 100)

            Button(isRunning ? "Detener" : "Empezar") {
                isRunning ? stop() : start()
            }
            .tint(Color.renuevoAccent)
        }
        .padding()
        .onDisappear { stop() }
    }

    private func start() {
        isRunning = true
        phase = .inhale
        WKInterfaceDevice.current().play(.start)
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
        WKInterfaceDevice.current().play(.click)
        switch phase {
        case .inhale: phase = .hold
        case .hold: phase = .exhale
        case .exhale: phase = .inhale
        }
        scheduleNext()
    }
}

#Preview {
    WatchBreathingView()
}
