import Foundation
import Combine

/// Persists goals, journal, habits, prayers and progress only on-device, via
/// UserDefaults + JSON. No account, no network by default — everything stays
/// on the user's phone unless iCloud sync is enabled (see `CloudSyncManager`).
final class DataStore: ObservableObject {
    static let shared = DataStore()

    @Published var goals: [Goal] = [] {
        didSet { save(goals, forKey: Keys.goals); CloudSyncManager.shared.pushAll() }
    }
    @Published var entries: [JournalEntry] = [] {
        didSet { save(entries, forKey: Keys.entries); CloudSyncManager.shared.pushAll() }
    }
    @Published var chatMessages: [ChatMessage] = [] {
        didSet { save(chatMessages, forKey: Keys.chatMessages) }
    }
    @Published var habits: [Habit] = [] {
        didSet { save(habits, forKey: Keys.habits); CloudSyncManager.shared.pushAll() }
    }
    @Published var prayerRequests: [PrayerRequest] = [] {
        didSet { save(prayerRequests, forKey: Keys.prayerRequests); CloudSyncManager.shared.pushAll() }
    }
    @Published var readingProgress: [String: ReadingPlanProgress] = [:] {
        didSet { save(readingProgress, forKey: Keys.readingProgress) }
    }
    @Published var memorizationCards: [Int: MemorizationCard] = [:] {
        didSet { save(memorizationCards, forKey: Keys.memorizationCards) }
    }
    @Published var appOpenDayKeys: Set<String> = [] {
        didSet { save(appOpenDayKeys, forKey: Keys.appOpenDayKeys) }
    }

    private enum Keys {
        static let goals = "renuevo.goals.v1"
        static let entries = "renuevo.journal.v1"
        static let chatMessages = "renuevo.chat.v1"
        static let habits = "renuevo.habits.v1"
        static let prayerRequests = "renuevo.prayers.v1"
        static let readingProgress = "renuevo.readingProgress.v1"
        static let memorizationCards = "renuevo.memorization.v1"
        static let appOpenDayKeys = "renuevo.appOpenDayKeys.v1"
    }

    private init() {
        goals = load([Goal].self, forKey: Keys.goals) ?? []
        entries = load([JournalEntry].self, forKey: Keys.entries) ?? []
        chatMessages = load([ChatMessage].self, forKey: Keys.chatMessages) ?? []
        habits = load([Habit].self, forKey: Keys.habits) ?? []
        prayerRequests = load([PrayerRequest].self, forKey: Keys.prayerRequests) ?? []
        readingProgress = load([String: ReadingPlanProgress].self, forKey: Keys.readingProgress) ?? [:]
        memorizationCards = load([Int: MemorizationCard].self, forKey: Keys.memorizationCards) ?? [:]
        appOpenDayKeys = load(Set<String>.self, forKey: Keys.appOpenDayKeys) ?? []
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

    // MARK: - Habits

    func addHabit(_ habit: Habit) {
        habits.append(habit)
    }

    func updateHabit(_ habit: Habit) {
        guard let index = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        habits[index] = habit
    }

    func toggleHabitToday(_ habit: Habit) {
        guard let index = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        let key = Date().dayKey
        if habits[index].completedDayKeys.contains(key) {
            habits[index].completedDayKeys.remove(key)
        } else {
            habits[index].completedDayKeys.insert(key)
        }
    }

    func deleteHabits(at offsets: IndexSet) {
        habits.remove(atOffsets: offsets)
    }

    func removeHabit(id: UUID) {
        habits.removeAll { $0.id == id }
    }

    /// Fraction of active habits completed today, for the insights dashboard.
    var todayHabitCompletionRate: Double {
        let active = habits.filter { !$0.isArchived }
        guard !active.isEmpty else { return 0 }
        let done = active.filter { $0.isCompleted() }.count
        return Double(done) / Double(active.count)
    }

    // MARK: - Prayers

    func addPrayer(_ prayer: PrayerRequest) {
        prayerRequests.insert(prayer, at: 0)
    }

    func updatePrayer(_ prayer: PrayerRequest) {
        guard let index = prayerRequests.firstIndex(where: { $0.id == prayer.id }) else { return }
        prayerRequests[index] = prayer
    }

    func markPrayerAnswered(_ prayer: PrayerRequest, note: String = "") {
        guard let index = prayerRequests.firstIndex(where: { $0.id == prayer.id }) else { return }
        prayerRequests[index].isAnswered = true
        prayerRequests[index].answeredDate = Date()
        prayerRequests[index].answeredNote = note
    }

    func deletePrayers(at offsets: IndexSet) {
        prayerRequests.remove(atOffsets: offsets)
    }

    // MARK: - Reading plans

    func progress(forPlan planId: String) -> ReadingPlanProgress {
        readingProgress[planId] ?? ReadingPlanProgress(planId: planId)
    }

    func markReadingDayCompleted(planId: String, day: Int) {
        var progress = progress(forPlan: planId)
        progress.completedDayIDs.insert(day)
        progress.lastCompletedAt = Date()
        readingProgress[planId] = progress
    }

    // MARK: - Memorization

    func memorizationCard(forQuoteId quoteId: Int) -> MemorizationCard {
        memorizationCards[quoteId] ?? MemorizationCard(id: quoteId)
    }

    func addMemorizationCard(quoteId: Int) {
        guard memorizationCards[quoteId] == nil else { return }
        memorizationCards[quoteId] = MemorizationCard(id: quoteId)
    }

    func removeMemorizationCard(quoteId: Int) {
        memorizationCards.removeValue(forKey: quoteId)
    }

    func recordMemorizationReview(quoteId: Int, correct: Bool) {
        let current = memorizationCard(forQuoteId: quoteId)
        memorizationCards[quoteId] = Memorization.review(current, correct: correct)
    }

    var dueMemorizationCards: [MemorizationCard] {
        memorizationCards.values.filter { $0.isDue }.sorted { $0.nextReviewDate < $1.nextReviewDate }
    }

    // MARK: - Streaks

    /// Marks today as "active" (the app was opened). Call once per launch/foreground.
    func recordAppOpen() {
        appOpenDayKeys.insert(Date().dayKey)
    }

    /// All calendar days with any sign of engagement: opening the app, journaling,
    /// or completing at least one habit.
    private var activeDayKeys: Set<String> {
        var keys = appOpenDayKeys
        keys.formUnion(entries.map { $0.date.dayKey })
        for habit in habits {
            keys.formUnion(habit.completedDayKeys)
        }
        return keys
    }

    /// Consecutive active days ending today (or yesterday, so the streak doesn't
    /// look broken before today's activity has happened yet).
    var currentStreak: Int {
        let keys = activeDayKeys
        var streak = 0
        var cursor = Date()
        if !keys.contains(cursor.dayKey) {
            cursor = cursor.addingDays(-1)
        }
        while keys.contains(cursor.dayKey) {
            streak += 1
            cursor = cursor.addingDays(-1)
        }
        return streak
    }

    var goalCompletionRate: Double {
        guard !goals.isEmpty else { return 0 }
        return Double(goals.filter { $0.isCompleted }.count) / Double(goals.count)
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
