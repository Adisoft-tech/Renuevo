import SwiftUI

@main
struct RenuevoApp: App {
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .onAppear {
                    NotificationManager.shared.requestAuthorizationIfNeeded()
                    DataStore.shared.recordAppOpen()
                    CloudSyncManager.shared.startIfEnabled()
                }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                // Keep the rolling 60-day notification window topped off.
                NotificationManager.shared.refreshSchedule()
                DataStore.shared.recordAppOpen()
            }
        }
    }
}
