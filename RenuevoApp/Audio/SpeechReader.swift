import Foundation
import AVFoundation
import SwiftUI

/// Thin wrapper around `AVSpeechSynthesizer` so any view can offer a "listen"
/// button for a reflection or prayer, entirely on-device (no network, no account).
final class SpeechReader: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    @Published var isSpeaking = false

    private let synthesizer = AVSpeechSynthesizer()

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func toggle(_ text: String) {
        if isSpeaking {
            stop()
        } else {
            speak(text)
        }
    }

    func speak(_ text: String) {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
        try? AVAudioSession.sharedInstance().setActive(true, options: [])

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "es-ES") ?? AVSpeechSynthesisVoice(language: "es-MX")
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.95
        synthesizer.speak(utterance)
        isSpeaking = true
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async { self.isSpeaking = false }
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        DispatchQueue.main.async { self.isSpeaking = false }
    }
}

/// A small "Escuchar" / "Detener" button that reads `text` aloud on-device.
struct SpeechButton: View {
    @ObservedObject var speech: SpeechReader
    let text: String

    var body: some View {
        Button {
            speech.toggle(text)
        } label: {
            Label(speech.isSpeaking ? "Detener" : "Escuchar", systemImage: speech.isSpeaking ? "stop.fill" : "speaker.wave.2.fill")
        }
        .buttonStyle(.bordered)
    }
}
