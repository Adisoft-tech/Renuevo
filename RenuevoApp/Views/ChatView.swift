import SwiftUI

struct ChatView: View {
    @ObservedObject private var store = DataStore.shared
    @State private var draft: String = ""

    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        if store.chatMessages.isEmpty {
                            VStack(spacing: 10) {
                                Image(systemName: "bubble.left.and.text.bubble.right")
                                    .font(.system(size: 36))
                                    .foregroundStyle(.secondary)
                                Text("Cuéntame cómo te sientes hoy")
                                    .font(.headline)
                                Text("Por ejemplo: \"Hoy me siento ansioso\" o \"Estoy agradecido pero cansado\".")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 60)
                        }

                        ForEach(store.chatMessages) { message in
                            ChatExchangeView(message: message)
                                .id(message.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: store.chatMessages.count) { _ in
                    if let last = store.chatMessages.last {
                        withAnimation {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }
            .navigationTitle("Chat")
            .toolbar {
                if !store.chatMessages.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Borrar", role: .destructive) {
                            store.clearChat()
                        }
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                HStack(spacing: 10) {
                    TextField("Hoy me siento...", text: $draft, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(1...4)

                    Button {
                        send()
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 30))
                    }
                    .disabled(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding()
                .background(.bar)
            }
        }
    }

    private func send() {
        let text = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        let response = MoodLibrary.respond(to: text)
        store.addChatMessage(ChatMessage(userText: text, response: response))
        draft = ""
    }
}

private struct ChatExchangeView: View {
    let message: ChatMessage
    @StateObject private var speech = SpeechReader()
    @State private var showingBreathing = false

    var body: some View {
        VStack(alignment: .trailing, spacing: 12) {
            Text(message.userText)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color.renuevoAccent.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .frame(maxWidth: .infinity, alignment: .trailing)

            VStack(alignment: .leading, spacing: 14) {
                ChatSection(title: "Pasaje", systemImage: "book") {
                    Text(message.response.passage)
                        .italic()
                    Text(message.response.passageReference)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                ChatSection(title: "Reflexión", systemImage: "text.book.closed") {
                    Text(message.response.reflection)
                }

                ChatSection(title: "Oración", systemImage: "hands.sparkles") {
                    Text(message.response.prayer)
                        .italic()
                }

                ChatSection(title: "Ejercicios para calmarte", systemImage: "leaf") {
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(message.response.exercises, id: \.self) { exercise in
                            HStack(alignment: .top, spacing: 6) {
                                Text("•")
                                Text(exercise)
                            }
                        }
                        Button {
                            showingBreathing = true
                        } label: {
                            Label("Hacer ejercicio de respiración guiado", systemImage: "wind")
                        }
                        .buttonStyle(.bordered)
                        .padding(.top, 4)
                    }
                }

                ChatSection(title: "Palabras de ánimo", systemImage: "heart.text.square") {
                    Text(message.response.encouragement)
                        .fontWeight(.medium)
                }

                SpeechButton(
                    speech: speech,
                    text: "\(message.response.passage). \(message.response.reflection). \(message.response.prayer)"
                )
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.renuevoBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .sheet(isPresented: $showingBreathing) {
            NavigationStack { BreathingView() }
        }
    }
}

private struct ChatSection<Content: View>: View {
    let title: String
    let systemImage: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Label(title, systemImage: systemImage)
                .font(.caption.bold())
                .foregroundStyle(Color.renuevoAccent)
            content
                .font(.subheadline)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ChatView()
}
