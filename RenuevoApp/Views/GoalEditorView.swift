import SwiftUI

struct GoalEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var store = DataStore.shared

    let existingGoal: Goal?

    @State private var title: String
    @State private var notes: String
    @State private var hasTargetDate: Bool
    @State private var targetDate: Date

    @State private var whyImportant: String
    @State private var valueRepresented: String
    @State private var fearHoldingBack: String
    @State private var nextSmallStep: String
    @State private var spiritualInspiration: String

    init(goal: Goal?) {
        self.existingGoal = goal
        _title = State(initialValue: goal?.title ?? "")
        _notes = State(initialValue: goal?.notes ?? "")
        _hasTargetDate = State(initialValue: goal?.targetDate != nil)
        _targetDate = State(initialValue: goal?.targetDate ?? Date())
        _whyImportant = State(initialValue: goal?.whyImportant ?? "")
        _valueRepresented = State(initialValue: goal?.valueRepresented ?? "")
        _fearHoldingBack = State(initialValue: goal?.fearHoldingBack ?? "")
        _nextSmallStep = State(initialValue: goal?.nextSmallStep ?? "")
        _spiritualInspiration = State(initialValue: goal?.spiritualInspiration ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Meta") {
                    TextField("¿Qué quieres lograr?", text: $title, axis: .vertical)
                }
                Section("Notas") {
                    TextField("Detalles, por qué importa...", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
                Section {
                    Toggle("Fecha objetivo", isOn: $hasTargetDate)
                    if hasTargetDate {
                        DatePicker("Fecha", selection: $targetDate, displayedComponents: .date)
                    }
                }

                Section {
                    GuidedQuestionField(
                        question: "¿Por qué esta meta es importante?",
                        text: $whyImportant
                    )
                    GuidedQuestionField(
                        question: "¿Qué valor representa? (amor, paciencia, servicio...)",
                        text: $valueRepresented
                    )
                    GuidedQuestionField(
                        question: "¿Qué miedo me impide lograrla?",
                        text: $fearHoldingBack
                    )
                    GuidedQuestionField(
                        question: "¿Qué pequeño paso puedo dar hoy?",
                        text: $nextSmallStep
                    )
                    GuidedQuestionField(
                        question: "¿Qué enseñanza espiritual me inspira?",
                        text: $spiritualInspiration
                    )
                } header: {
                    Text("Reflexión guiada")
                } footer: {
                    Text("No es obligatorio responder todo de una vez. Puedes volver a esta meta más adelante y seguir completándola.")
                }
            }
            .navigationTitle(existingGoal == nil ? "Nueva meta" : "Editar meta")
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
        var goal = existingGoal ?? Goal(title: "")
        goal.title = title
        goal.notes = notes
        goal.targetDate = hasTargetDate ? targetDate : nil
        goal.whyImportant = whyImportant
        goal.valueRepresented = valueRepresented
        goal.fearHoldingBack = fearHoldingBack
        goal.nextSmallStep = nextSmallStep
        goal.spiritualInspiration = spiritualInspiration

        if existingGoal == nil {
            store.addGoal(goal)
        } else {
            store.updateGoal(goal)
        }
    }
}

private struct GuidedQuestionField: View {
    let question: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(question)
                .font(.subheadline.weight(.medium))
            TextField("Tu respuesta...", text: $text, axis: .vertical)
                .lineLimit(2...5)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    GoalEditorView(goal: nil)
}
