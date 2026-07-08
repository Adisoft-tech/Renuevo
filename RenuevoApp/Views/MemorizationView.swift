import SwiftUI

struct MemorizationView: View {
    @ObservedObject private var store = DataStore.shared
    @State private var showingAddSheet = false

    private var savedCards: [MemorizationCard] {
        store.memorizationCards.values.sorted { $0.addedAt < $1.addedAt }
    }

    private var dueCards: [MemorizationCard] { store.dueMemorizationCards }

    var body: some View {
        List {
            if !dueCards.isEmpty {
                Section {
                    NavigationLink {
                        MemorizationReviewView(cards: dueCards)
                    } label: {
                        Label("Repasar \(dueCards.count) versículo\(dueCards.count == 1 ? "" : "s") pendiente\(dueCards.count == 1 ? "" : "s")", systemImage: "rectangle.stack.fill")
                            .font(.headline)
                    }
                }
            }

            Section {
                if savedCards.isEmpty {
                    Text("Aún no guardas versículos para memorizar. Toca + para elegir uno.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(savedCards) { card in
                        if let quote = QuoteLibrary.all.first(where: { $0.id == card.id }) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(quote.reference).font(.subheadline.bold())
                                Text(quote.text)
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                                Text(card.isDue ? "Listo para repasar" : "Próximo repaso: \(card.nextReviewDate, style: .date)")
                                    .font(.caption2)
                                    .foregroundStyle(card.isDue ? .green : .secondary)
                            }
                        }
                    }
                    .onDelete { offsets in
                        offsets.map { savedCards[$0].id }.forEach(store.removeMemorizationCard)
                    }
                }
            } header: {
                Text("Tus versículos")
            } footer: {
                Text("Cada acierto lo espacía más en el tiempo; cada fallo lo trae de vuelta pronto, como un mazo de tarjetas clásico.")
            }
        }
        .navigationTitle("Memorización")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingAddSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            AddMemorizationCardView()
        }
    }
}

private struct AddMemorizationCardView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var store = DataStore.shared

    var body: some View {
        NavigationStack {
            List(QuoteLibrary.all) { quote in
                let alreadyAdded = store.memorizationCards[quote.id] != nil
                Button {
                    store.addMemorizationCard(quoteId: quote.id)
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(quote.reference).font(.subheadline.bold())
                            Text(quote.text)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                        Spacer()
                        if alreadyAdded {
                            Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
                        } else {
                            Image(systemName: "plus.circle").foregroundStyle(Color.renuevoAccent)
                        }
                    }
                }
                .buttonStyle(.plain)
                .disabled(alreadyAdded)
            }
            .navigationTitle("Elegir versículo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Listo") { dismiss() }
                }
            }
        }
    }
}

struct MemorizationReviewView: View {
    let cards: [MemorizationCard]
    @ObservedObject private var store = DataStore.shared
    @State private var currentIndex = 0
    @State private var isRevealed = false

    var body: some View {
        VStack(spacing: 24) {
            if currentIndex < cards.count, let quote = quote(for: cards[currentIndex]) {
                Spacer()

                Text("\(currentIndex + 1) de \(cards.count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                VStack(spacing: 16) {
                    Text(quote.reference)
                        .font(.title3.bold())

                    if isRevealed {
                        Text(quote.text)
                            .font(.title3.weight(.medium))
                            .multilineTextAlignment(.center)
                            .transition(.opacity)
                    } else {
                        Text("Toca para revelar el versículo")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(24)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 180)
                .background(Color.renuevoBackground)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation { isRevealed.toggle() }
                }
                .padding(.horizontal)

                Spacer()

                if isRevealed {
                    HStack(spacing: 16) {
                        Button {
                            answer(correct: false, quoteId: quote.id)
                        } label: {
                            Label("No lo recordé", systemImage: "arrow.counterclockwise")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)

                        Button {
                            answer(correct: true, quoteId: quote.id)
                        } label: {
                            Label("Lo recordé", systemImage: "checkmark")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                }
            } else {
                Spacer()
                VStack(spacing: 12) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 44))
                        .foregroundStyle(.green)
                    Text("¡Repaso completado!").font(.headline)
                }
                Spacer()
            }
        }
        .navigationTitle("Repaso")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func quote(for card: MemorizationCard) -> Quote? {
        QuoteLibrary.all.first { $0.id == card.id }
    }

    private func answer(correct: Bool, quoteId: Int) {
        store.recordMemorizationReview(quoteId: quoteId, correct: correct)
        isRevealed = false
        currentIndex += 1
    }
}

#Preview {
    NavigationStack { MemorizationView() }
}
