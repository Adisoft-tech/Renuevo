import SwiftUI

struct JournalEntryEditor: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var store = DataStore.shared

    let existingEntry: JournalEntry?

    @State private var mood: String
    @State private var text: String
    private var quoteOfDay: Quote { QuoteLibrary.quote(for: existingEntry?.date ?? Date()) }

    init(existingEntry: JournalEntry?, initialText: String = "") {
        self.existingEntry = existingEntry
        _mood = State(initialValue: existingEntry?.mood ?? MoodOption.happy.rawValue)
        _text = State(initialValue: existingEntry?.text ?? initialText)
    }

    var body: some View {
        Form {
            Section("¿Cómo te sientes hoy?") {
                Picker("Estado de ánimo", selection: $mood) {
                    ForEach(MoodOption.allCases, id: \.rawValue) { option in
                        Text(option.rawValue).tag(option.rawValue)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section("Mensaje de hoy") {
                Text("\(quoteOfDay.text) — \(quoteOfDay.reference)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section("Escribe libremente") {
                TextEditor(text: $text)
                    .frame(minHeight: 180)
            }
        }
        .navigationTitle(existingEntry == nil ? "Nueva entrada" : "Editar entrada")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancelar") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Guardar") {
                    save()
                    dismiss()
                }
                .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
    }

    private func save() {
        var entry = existingEntry ?? JournalEntry()
        entry.mood = mood
        entry.text = text

        if existingEntry == nil {
            store.addEntry(entry)
        } else {
            store.updateEntry(entry)
        }
    }
}

#Preview {
    NavigationStack {
        JournalEntryEditor(existingEntry: nil)
    }
}
