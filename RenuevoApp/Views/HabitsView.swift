import SwiftUI

struct HabitsView: View {
    @ObservedObject private var store = DataStore.shared
    @State private var showingNewHabit = false

    private var activeHabits: [Habit] {
        store.habits.filter { !$0.isArchived }
    }

    var body: some View {
        Group {
            if activeHabits.isEmpty {
                ContentUnavailableFallback(
                    title: "Aún no tienes hábitos",
                    message: "Toca + para crear un hábito diario, como orar, leer o hacer ejercicio.",
                    systemImage: "repeat.circle"
                )
            } else {
                List {
                    Section {
                        ForEach(activeHabits) { habit in
                            HabitRow(habit: habit)
                        }
                        .onDelete { offsets in
                            offsets.map { activeHabits[$0].id }.forEach(store.removeHabit)
                        }
                    } footer: {
                        Text("Marca cada hábito cuando lo completes hoy. La racha cuenta los días seguidos.")
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingNewHabit = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingNewHabit) {
            HabitEditorView()
        }
    }
}

private struct HabitRow: View {
    @ObservedObject private var store = DataStore.shared
    let habit: Habit

    var body: some View {
        HStack(spacing: 12) {
            Button {
                store.toggleHabitToday(habit)
            } label: {
                Image(systemName: habit.isCompleted() ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(habit.isCompleted() ? .green : .secondary)
                    .font(.title2)
            }
            .buttonStyle(.plain)

            Image(systemName: habit.icon)
                .foregroundStyle(Color.renuevoAccent)
                .frame(width: 22)

            VStack(alignment: .leading, spacing: 3) {
                Text(habit.title)
                    .foregroundStyle(habit.isCompleted() ? .secondary : .primary)
                if habit.currentStreak > 0 {
                    Label("\(habit.currentStreak) día\(habit.currentStreak == 1 ? "" : "s") seguidos", systemImage: "flame.fill")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
            }

            Spacer()
        }
        .contentShape(Rectangle())
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

struct HabitEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var store = DataStore.shared

    @State private var title = ""
    @State private var icon = "hands.sparkles.fill"

    private let iconChoices = [
        "hands.sparkles.fill", "book.closed.fill", "figure.walk", "drop.fill",
        "moon.stars.fill", "heart.fill", "leaf.fill", "cup.and.saucer.fill",
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section("Hábito") {
                    TextField("Ej. Orar 10 minutos", text: $title)
                }
                Section("Ícono") {
                    let columns = Array(repeating: GridItem(.flexible()), count: 4)
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(iconChoices, id: \.self) { candidate in
                            Button {
                                icon = candidate
                            } label: {
                                Image(systemName: candidate)
                                    .font(.title2)
                                    .frame(maxWidth: .infinity, minHeight: 40)
                                    .foregroundStyle(icon == candidate ? Color.white : Color.renuevoAccent)
                                    .background(icon == candidate ? Color.renuevoAccent : Color.renuevoAccent.opacity(0.12))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Nuevo hábito")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        store.addHabit(Habit(title: title, icon: icon))
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

#Preview {
    NavigationStack { HabitsView() }
}
