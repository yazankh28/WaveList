import SwiftUI
import SwiftData

@main
struct WaveListApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .modelContainer(for: [SavedSong.self, SavedArtist.self])
        }
    }
}
