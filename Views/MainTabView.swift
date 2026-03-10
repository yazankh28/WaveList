import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            TrendingView()
                .tabItem {
                    Label("Trending", systemImage: "flame.fill")
                }
            
            NavigationStack {
                SavedView()
            }
            .tabItem {
                Label("Sparade", systemImage: "heart.fill")
            }
        }
        .tint(.orange)
        .preferredColorScheme(.dark)
    }
}
