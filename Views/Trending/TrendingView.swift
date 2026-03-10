import SwiftUI

struct TrendingView: View {
    @StateObject private var viewModel = TrendingViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                } else if let error = viewModel.errorMessage {
                    VStack {
                        Text("⚠️ \(error)")
                            .foregroundStyle(.white)
                        Button("Försök igen") {
                            Task { await viewModel.fetchTracks() }
                        }
                        .foregroundStyle(.orange)
                    }
                } else {
                    List {
                        ForEach(Array(viewModel.tracks.enumerated()), id: \.offset) { index, track in
                            NavigationLink(destination: SongDetailView(track: track)) {
                                TrackRowView(track: track, rank: index + 1)
                            }
                            .listRowBackground(Color.black)
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Trending 🔥")
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(.dark)
            .task {
                await viewModel.fetchTracks()
            }
        }
    }
}
