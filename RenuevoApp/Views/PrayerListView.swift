import SwiftUI

struct PrayerListView: View {
    @ObservedObject private var store = DataStore.shared
    @State private var showingNewPrayer = false

    private var pending: [PrayerRequest] { store.prayerRequests.filter { !$0.isAnswered } }
    private var answered: [PrayerRequest] { store.prayerRequests.filter { $0.isAnswered } }

    var body: some View {
        Group {
            if store.prayerRequests.isEmpty {
                ContentUnavailableFallback(
                    title: "Tu lista de oración está vacía",
                    message: "Toca + para anotar una petición. Cuando sea respondida, márcala y guarda el testimonio.",
                    systemImage: "hands.sparkles"
                )
            } else {
                List {
                    if !pending.isEmpty {
                        Section("Peticiones") {
                            ForEach(pending) { prayer in
                                PrayerRow(prayer: prayer)
                            }
                            .onDelete { offsets in
                                offsets.map { pending[$0].id }.forEach(removePrayer)
                            }
                        }
                    }
                    if !answered.isEmpty {
                        Section("Respondidas") {
                            ForEach(answered) { prayer in
                                PrayerRow(prayer: prayer)
                            }
                            .onDelete { offsets in
                                offsets.map { answered[$0].id }.forEach(removePrayer)
                            }
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingNewPrayer = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingNewPrayer) {
            PrayerEditorView(prayer: nil)
        }
    }

    private func removePrayer(id: UUID) {
        store.prayerRequests.removeAll { $0.id == id }
    }
}

private struct PrayerRow: View {
    @ObservedObject private var store = DataStore.shared
    let prayer: PrayerRequest
    @State private var showingAnsweredSheet = false
    @State private var showingEditor = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(prayer.title)
                        .strikethrough(prayer.isAnswered)
                        .foregroundStyle(prayer.isAnswered ? .secondary : .primary)
                    if !prayer.notes.isEmpty {
                        Text(prayer.notes)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                    Text(prayer.date, style: .date)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                if !prayer.isAnswered {
                    Button {
                        showingAnsweredSheet = true
                    } label: {
                        Image(systemName: "checkmark.circle")
                    }
                    .buttonStyle(.plain)
                }
            }
            if prayer.isAnswered {
                Label("Respondida", systemImage: "sparkles")
                    .font(.caption.bold())
                    .foregroundStyle(.green)
                if !prayer.answeredNote.isEmpty {
                    Text(prayer.answeredNote)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { showingEditor = true }
        .sheet(isPresented: $showingEditor) {
            PrayerEditorView(prayer: prayer)
        }
        .sheet(isPresented: $showingAnsweredSheet) {
            MarkAnsweredView(prayer: prayer)
        }
    }
}

private struct MarkAnsweredView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var store = DataStore.shared
    let prayer: PrayerRequest
    @State private var note = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("¿Cómo respondió Dios esta petición?") {
                    TextField("Cuenta brevemente el testimonio...", text: $note, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Petición respondida")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        store.markPrayerAnswered(prayer, note: note)
                        dismiss()
                    }
                }
            }
        }
    }
}

private struct ContentUnavailableFallback: View {
    let title: String
    let message: String
    let systemImage: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            Text(title).font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct PrayerEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var store = DataStore.shared
    let prayer: PrayerRequest?

    @State private var title: String
    @State private var notes: String

    init(prayer: PrayerRequest?) {
        self.prayer = prayer
        _title = State(initialValue: prayer?.title ?? "")
        _notes = State(initialValue: prayer?.notes ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Petición") {
                    TextField("¿Por qué quieres orar?", text: $title, axis: .vertical)
                }
                Section("Notas") {
                    TextField("Detalles adicionales...", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle(prayer == nil ? "Nueva petición" : "Editar petición")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        save()
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }

    private func save() {
        var updated = prayer ?? PrayerRequest(title: "")
        updated.title = title
        updated.notes = notes
        if prayer == nil {
            store.addPrayer(updated)
        } else {
            store.updatePrayer(updated)
        }
    }
}

#Preview {
    NavigationStack { PrayerListView() }
}
