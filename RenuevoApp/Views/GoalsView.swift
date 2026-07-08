import SwiftUI

struct GoalsView: View {
    @ObservedObject private var store = DataStore.shared
    @State private var showingNewGoal = false

    var body: some View {
        NavigationStack {
            Group {
                if store.goals.isEmpty {
                    ContentUnavailableFallback(
                        title: "Aún no tienes metas",
                        message: "Toca + para escribir tu primera meta, con preguntas guiadas para darle profundidad.",
                        systemImage: "target"
                    )
                } else {
                    List {
                        ForEach(store.goals) { goal in
                            GoalRow(goal: goal)
                        }
                        .onDelete(perform: store.deleteGoals)
                    }
                }
            }
            .navigationTitle("Metas")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingNewGoal = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewGoal) {
                GoalEditorView(goal: nil)
            }
        }
    }
}

private struct GoalRow: View {
    @ObservedObject private var store = DataStore.shared
    let goal: Goal
    @State private var showingEditor = false

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Button {
                store.toggleGoalCompletion(goal)
            } label: {
                Image(systemName: goal.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(goal.isCompleted ? .green : .secondary)
                    .font(.title3)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                Text(goal.title)
                    .strikethrough(goal.isCompleted)
                    .foregroundStyle(goal.isCompleted ? .secondary : .primary)
                if !goal.notes.isEmpty {
                    Text(goal.notes)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                if let targetDate = goal.targetDate {
                    Label {
                        Text(targetDate, style: .date)
                    } icon: {
                        Image(systemName: "calendar")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                if goal.hasGuidedReflection {
                    Label("Reflexión guiada", systemImage: "sparkles")
                        .font(.caption)
                        .foregroundStyle(Color.renuevoAccent)
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { showingEditor = true }
        .sheet(isPresented: $showingEditor) {
            GoalEditorView(goal: goal)
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

#Preview {
    GoalsView()
}
