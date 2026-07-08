import Foundation
import Combine

/// Persists goals and journal entries only on-device, via UserDefaults + JSON.
/// No account, no network, no server — everything stays on the user's phone.
final class DataStore: ObservableObject {
    static let shared = DataStore()

    @Published var goals: [Goal] = [] {
        didSet { save(goals, forKey: Keys.goals) }
    }
    @Published var entries: [JournalEntry] = [] {
        didSet { save(entries, forKey: Keys.entries) }
    }
    @Published var chatMessages: [ChatMessage] = [] {
        didSet { save(chatMessages, forKey: Keys.chatMessages) }
    }

    private enum Keys {
        static let goals = "renuevo.goals.v1"
        static let entries = "renuevo.journal.v1"
        static let chatMessages = "renuevo.chat.v1"
    }

    private init() {
        goals = load([Goal].self, forKey: Keys.goals) ?? []
        entries = load([JournalEntry].self, forKey: Keys.entries) ?? []
        chatMessages = load([ChatMessage].self, forKey: Keys.chatMessages) ?? []
    }

    // MARK: - Goals

    func addGoal(_ goal: Goal) {
        goals.insert(goal, at: 0)
    }

    func toggleGoalCompletion(_ goal: Goal) {
        guard let index = goals.firstIndex(where: { $0.id == goal.id }) else { return }
        goals[index].isCompleted.toggle()
    }

    func updateGoal(_ goal: Goal) {
        guard let index = goals.firstIndex(where: { $0.id == goal.id }) else { return }
        goals[index] = goal
    }

    func deleteGoals(at offsets: IndexSet) {
        goals.remove(atOffsets: offsets)
    }

    // MARK: - Journal

    func addEntry(_ entry: JournalEntry) {
        entries.insert(entry, at: 0)
    }

    func updateEntry(_ entry: JournalEntry) {
        guard let index = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[index] = entry
    }

    func deleteEntries(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
    }

    // MARK: - Chat

    func addChatMessage(_ message: ChatMessage) {
        chatMessages.append(message)
    }

    func clearChat() {
        chatMessages.removeAll()
    }

    // MARK: - Persistence helpers

    private func save<T: Encodable>(_ value: T, forKey key: String) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    private func load<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
