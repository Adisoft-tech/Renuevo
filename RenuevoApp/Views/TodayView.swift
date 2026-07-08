import SwiftUI

struct TodayView: View {
    @State private var showingSettings = false
    private var quote: Quote { QuoteLibrary.quote(for: Date()) }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 96)
                        .frame(maxWidth: .infinity)
                        .accessibilityLabel("Renuevo")

                    Text(Date(), style: .date)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)

                    VStack(alignment: .leading, spacing: 16) {
                        Label(quote.category.rawValue, systemImage: quote.category.symbol)
                            .font(.caption.bold())
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(quote.category.tint.opacity(0.15))
                            .foregroundStyle(quote.category.tint)
                            .clipShape(Capsule())

                        Text(quote.text)
                            .font(.title2.weight(.semibold))
                            .fixedSize(horizontal: false, vertical: true)

                        Text(quote.reference)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.renuevoBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                    ShareLink(item: "\(quote.text) — \(quote.reference)") {
                        Label("Compartir mensaje", systemImage: "square.and.arrow.up")
                    }
                    .buttonStyle(.bordered)

                    Divider().padding(.vertical, 4)

                    TodaySection(title: "Reflexión de hoy", systemImage: "text.book.closed") {
                        Text(quote.reflection)
                    }

                    TodaySection(title: "Enseñanza práctica", systemImage: "lightbulb") {
                        Text(quote.practicalTeaching)
                            .fontWeight(.medium)
                    }

                    TodaySection(title: "Pregunta para reflexionar", systemImage: "questionmark.circle") {
                        Text(quote.question)
                    }

                    TodaySection(title: "Acción concreta para hoy", systemImage: "checkmark.circle") {
                        Text(quote.action)
                    }

                    TodaySection(title: "Oración", systemImage: "hands.sparkles") {
                        Text(quote.prayer)
                            .italic()
                    }
                }
                .padding()
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                NotificationSettingsView()
            }
        }
    }
}

private struct TodaySection<Content: View>: View {
    let title: String
    let systemImage: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(title, systemImage: systemImage)
                .font(.headline)
                .foregroundStyle(Color.renuevoAccent)
            content
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct NotificationSettingsView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                ReminderSection(
                    kind: .dailyMessage,
                    title: "Mensaje del día",
                    description: "El mensaje de fe o motivación de hoy."
                )
                ReminderSection(
                    kind: .morningJournal,
                    title: "Pregunta de la mañana",
                    description: "La pregunta del mensaje de hoy, para ponerla en práctica durante el día."
                )
                ReminderSection(
                    kind: .eveningJournal,
                    title: "Reflexión de la noche",
                    description: "Aprendizajes del día, qué hiciste bien y qué mejorar."
                )
            }
            .navigationTitle("Notificaciones")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Listo") { dismiss() }
                }
            }
        }
    }
}

private struct ReminderSection: View {
    let kind: ReminderKind
    let title: String
    let description: String

    @State private var isEnabled: Bool
    @State private var time: Date

    init(kind: ReminderKind, title: String, description: String) {
        self.kind = kind
        self.title = title
        self.description = description
        _isEnabled = State(initialValue: NotificationManager.shared.isEnabled(for: kind))
        var components = DateComponents()
        components.hour = NotificationManager.shared.hour(for: kind)
        components.minute = NotificationManager.shared.minute(for: kind)
        _time = State(initialValue: Calendar.current.date(from: components) ?? Date())
    }

    var body: some View {
        Section {
            Toggle(title, isOn: $isEnabled)
                .onChange(of: isEnabled) { newValue in
                    NotificationManager.shared.setEnabled(newValue, for: kind)
                }
            if isEnabled {
                DatePicker("Hora", selection: $time, displayedComponents: .hourAndMinute)
                    .onChange(of: time) { newValue in
                        let components = Calendar.current.dateComponents([.hour, .minute], from: newValue)
                        NotificationManager.shared.setHour(components.hour ?? kind.defaultHour, for: kind)
                        NotificationManager.shared.setMinute(components.minute ?? kind.defaultMinute, for: kind)
                    }
            }
        } footer: {
            Text(description)
        }
    }
}

#Preview {
    TodayView()
}
