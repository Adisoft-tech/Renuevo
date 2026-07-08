import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            TodayView()
                .tabItem { Label("Hoy", systemImage: "sun.max.fill") }

            GoalsView()
                .tabItem { Label("Metas", systemImage: "target") }

            JournalView()
                .tabItem { Label("Diario", systemImage: "book.closed.fill") }

            ChatView()
                .tabItem { Label("Chat", systemImage: "bubble.left.and.text.bubble.right.fill") }
        }
        .tint(.renuevoAccent)
    }
}

#Preview {
    RootTabView()
}
