import SwiftUI

struct JournalView: View {
    @ObservedObject private var store = DataStore.shared
    @State private var showingNewEntry = false
    @State private var newEntryTemplate = ""
    private var quote: Quote { QuoteLibrary.quote(for: Date()) }

    var body: some View {
        NavigationStack {
            List {
                Section("Preguntas de hoy") {
                    PromptRow(
                        icon: "sun.max.fill",
                        title: "Pregunta de la mañana",
                        prompt: quote.question
                    ) {
                        newEntryTemplate = "☀️ \(quote.question)\n\n"
                        showingNewEntry = true
                    }

                    PromptRow(
                        icon: "moon.stars.fill",
                        title: "Reflexión de la noche",
                        prompt: "Tres aprendizajes de hoy, qué hiciste bien y en qué puedes mejorar."
                    ) {
                        newEntryTemplate = """
                        🌙 Tres aprendizajes de hoy:
                        1.
                        2.
                        3.

                        ¿Qué hice bien hoy?


                        ¿En qué puedo mejorar mañana?


                        """
                        showingNewEntry = true
                    }
                }

                if store.entries.isEmpty {
                    Section {
                        VStack(spacing: 10) {
                            Image(systemName: "book.closed")
                                .font(.system(size: 34))
                                .foregroundStyle(.secondary)
                            Text("Tu diario está vacío")
                                .font(.headline)
                            Text("Responde una pregunta de arriba o toca + para escribir libremente.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                    }
                } else {
                    Section("Entradas") {
                        ForEach(store.entries) { entry in
                            NavigationLink(value: entry) {
                                JournalRow(entry: entry)
                            }
                        }
                        .onDelete(perform: store.deleteEntries)
                    }
                }
            }
            .navigationTitle("Diario")
            .navigationDestination(for: JournalEntry.self) { entry in
                JournalEntryEditor(existingEntry: entry)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        newEntryTemplate = ""
                        showingNewEntry = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewEntry) {
                NavigationStack {
                    JournalEntryEditor(existingEntry: nil, initialText: newEntryTemplate)
                }
            }
        }
    }
}

private struct PromptRow: View {
    let icon: String
    let title: String
    let prompt: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: icon)
                    .foregroundStyle(Color.renuevoAccent)
                    .frame(width: 20)
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                    Text(prompt)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                Spacer()
                Image(systemName: "square.and.pencil")
                    .foregroundStyle(.secondary)
            }
        }
        .buttonStyle(.plain)
    }
}

private struct JournalRow: View {
    let entry: JournalEntry

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(entry.mood).font(.title2)
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.date, style: .date)
                    .font(.subheadline.bold())
                Text(entry.text)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
    }
}

#Preview {
    JournalView()
}
