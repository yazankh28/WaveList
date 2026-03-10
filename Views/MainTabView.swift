import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            SearchView()
                .tabItem {
                    Label("Sök", systemImage: "magnifyingglass")
                }
                .tag(0)
            
            TrendingView()
                .tabItem {
                    Label("Trending", systemImage: "flame.fill")
                }
                .tag(1)
            
            NavigationStack {
                SavedView()
            }
            .tabItem {
                Label("Sparade", systemImage: "heart.fill")
            }
            .tag(2)
        }
        .tint(.orange)
        .preferredColorScheme(.dark)
    }
}
