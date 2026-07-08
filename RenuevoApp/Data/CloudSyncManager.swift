import Foundation

/// Best-effort, opt-in iCloud sync via `NSUbiquitousKeyValueStore` — no CloudKit
/// container needed, so it works with the same free-tier signing already used
/// by this project. When enabled, it mirrors goals, journal entries, habits and
/// prayer requests (the four collections worth carrying across devices) into
/// iCloud's small per-account key-value store, so they follow the user to their
/// other devices signed into the same iCloud account.
///
/// Off by default: this app is local-first by design (see README), so syncing
/// is an explicit opt-in, not a silent background upload.
///
/// Known limitations, given the scope of this change:
/// - `NSUbiquitousKeyValueStore` caps total storage at ~1MB account-wide, so an
///   extremely long journal history may not fully fit.
/// - Merges use a union-by-id strategy where local always wins on conflict, and
///   a remote item disappearing never deletes the local copy — so a deletion
///   made on one device won't remove that item from another device's sync copy.
///   Both caveats would go away with a real CloudKit record-based sync, which is
///   a substantially bigger change than this one.
/// - Requires the simulator/device to actually be signed into iCloud to do
///   anything observable; it fails silently (no crash) otherwise.
final class CloudSyncManager {
    static let shared = CloudSyncManager()

    private let store = NSUbiquitousKeyValueStore.default
    private var isObserving = false

    private enum Keys {
        static let enabled = "renuevo.icloudSyncEnabled"
        static let goals = "renuevo.sync.goals.v1"
        static let entries = "renuevo.sync.journal.v1"
        static let habits = "renuevo.sync.habits.v1"
        static let prayers = "renuevo.sync.prayers.v1"
    }

    var isEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: Keys.enabled) }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.enabled)
            if newValue {
                start()
                pushAll()
            } else {
                stop()
            }
        }
    }

    /// Call on app launch: resumes observing + pulls remote changes if the user
    /// had already turned sync on in a previous session.
    func startIfEnabled() {
        guard isEnabled else { return }
        start()
        pullAll()
    }

    private func start() {
        guard !isObserving else { return }
        isObserving = true
        NotificationCenter.default.addObserver(
            self, selector: #selector(externalChange(_:)),
            name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
            object: store
        )
        store.synchronize()
    }

    private func stop() {
        guard isObserving else { return }
        isObserving = false
        NotificationCenter.default.removeObserver(
            self, name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: store
        )
    }

    @objc private func externalChange(_ note: Notification) {
        pullAll()
    }

    /// Pushes the current local state up to iCloud. Safe to call often — it's
    /// cheap JSON, and `DataStore` calls this after every local edit.
    func pushAll() {
        guard isEnabled else { return }
        let dataStore = DataStore.shared
        write(dataStore.goals, key: Keys.goals)
        write(dataStore.entries, key: Keys.entries)
        write(dataStore.habits, key: Keys.habits)
        write(dataStore.prayerRequests, key: Keys.prayers)
        store.synchronize()
    }

    private func pullAll() {
        guard isEnabled else { return }
        DispatchQueue.main.async {
            let dataStore = DataStore.shared
            if let remote: [Goal] = self.read(Keys.goals) {
                dataStore.goals = Self.merge(local: dataStore.goals, remote: remote)
                    .sorted { $0.createdAt > $1.createdAt }
            }
            if let remote: [JournalEntry] = self.read(Keys.entries) {
                dataStore.entries = Self.merge(local: dataStore.entries, remote: remote)
                    .sorted { $0.date > $1.date }
            }
            if let remote: [Habit] = self.read(Keys.habits) {
                dataStore.habits = Self.merge(local: dataStore.habits, remote: remote)
                    .sorted { $0.createdAt < $1.createdAt }
            }
            if let remote: [PrayerRequest] = self.read(Keys.prayers) {
                dataStore.prayerRequests = Self.merge(local: dataStore.prayerRequests, remote: remote)
                    .sorted { $0.date > $1.date }
            }
        }
    }

    /// Union by id; local wins when the same id exists in both, so this device's
    /// in-flight edits are never clobbered by a slightly stale remote copy.
    private static func merge<T: Identifiable & Codable>(local: [T], remote: [T]) -> [T] where T.ID: Hashable {
        var byId: [T.ID: T] = [:]
        for item in remote { byId[item.id] = item }
        for item in local { byId[item.id] = item }
        return Array(byId.values)
    }

    private func write<T: Encodable>(_ value: T, key: String) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        store.set(data, forKey: key)
    }

    private func read<T: Decodable>(_ key: String) -> T? {
        guard let data = store.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
