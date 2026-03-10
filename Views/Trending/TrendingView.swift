import SwiftUI

struct TrendingView: View {
    @StateObject private var viewModel = TrendingViewModel()
    @State private var searchText = ""
    
    var filteredTracks: [Track] {
        if searchText.isEmpty {
            return viewModel.tracks
        }
        return viewModel.tracks.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.artist.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                if viewModel.isLoading {
                    VStack(spacing: 16) {
                        ProgressView()
                            .tint(.orange)
                            .scaleEffect(1.5)
                        Text("Laddar trender...")
                            .foregroundStyle(.gray)
                            .font(.subheadline)
                    }
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Text("⚠️")
                            .font(.system(size: 50))
                        Text(error)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                        Button("Försök igen") {
                            Task { await viewModel.fetchTracks() }
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                        .background(Color.orange)
                        .cornerRadius(20)
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(Array(filteredTracks.enumerated()), id: \.offset) { index, track in
                                NavigationLink(destination: SongDetailView(track: track)) {
                                    TrackRowView(track: track, rank: index + 1)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                }
            }
            .navigationTitle("Trending 🔥")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Sök låt eller artist...")
            .preferredColorScheme(.dark)
            .toolbar {
                NavigationLink(destination: NotificationSettingsView()) {
                    Image(systemName: "bell")
                        .foregroundStyle(.orange)
                }
            }
            .task {
                await viewModel.fetchTracks()
            }
        }
    }
}
