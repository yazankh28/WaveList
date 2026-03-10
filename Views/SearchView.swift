import SwiftUI
import Combine

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var searchText = ""
    @State private var searchTask: Task<Void, Never>?
    @AppStorage("searchHistory") private var historyData: String = ""
    
    var searchHistory: [String] {
        historyData.split(separator: ",").map(String.init).filter { !$0.isEmpty }
    }
    
    func addToHistory(_ query: String) {
        var history = searchHistory
        history.removeAll { $0 == query }
        history.insert(query, at: 0)
        let trimmed = Array(history.prefix(8))
        historyData = trimmed.joined(separator: ",")
    }
    
    func removeFromHistory(_ query: String) {
        var history = searchHistory
        history.removeAll { $0 == query }
        historyData = history.joined(separator: ",")
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    if !viewModel.hasSearched && searchText.isEmpty {
                        if searchHistory.isEmpty {
                            VStack(spacing: 16) {
                                Spacer()
                                Text("🎵")
                                    .font(.system(size: 70))
                                Text("Sök efter låtar & artister")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                Text("Hitta info om vilken låt eller artist som helst")
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                                Spacer()
                            }
                        } else {
                            // Sökhistorik
                            List {
                                Section {
                                    ForEach(searchHistory, id: \.self) { query in
                                        Button {
                                            searchText = query
                                            Task { await viewModel.search(query: query) }
                                        } label: {
                                            HStack {
                                                Image(systemName: "clock")
                                                    .foregroundStyle(.gray)
                                                Text(query)
                                                    .foregroundStyle(.white)
                                                Spacer()
                                                Button {
                                                    removeFromHistory(query)
                                                } label: {
                                                    Image(systemName: "xmark")
                                                        .foregroundStyle(.gray)
                                                        .font(.system(size: 12))
                                                }
                                            }
                                        }
                                        .listRowBackground(Color.white.opacity(0.05))
                                    }
                                } header: {
                                    Text("Senaste sökningar")
                                        .foregroundStyle(.orange)
                                }
                            }
                            .listStyle(.insetGrouped)
                            .scrollContentBackground(.hidden)
                        }
                    } else if viewModel.isLoading {
                        Spacer()
                        ProgressView()
                            .tint(.orange)
                            .scaleEffect(1.5)
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVStack(alignment: .leading, spacing: 0) {
                                if !viewModel.artists.isEmpty {
                                    Text("ARTISTER")
                                        .font(.system(size: 11, weight: .black))
                                        .foregroundStyle(.orange)
                                        .padding(.horizontal)
                                        .padding(.top, 16)
                                        .padding(.bottom, 8)
                                    
                                    ForEach(viewModel.artists) { artist in
                                        NavigationLink(destination: ArtistView(artistName: artist.name)) {
                                            ArtistRowView(artist: artist)
                                        }
                                        .buttonStyle(.plain)
                                        .padding(.horizontal)
                                        .padding(.bottom, 8)
                                    }
                                }
                                
                                if !viewModel.tracks.isEmpty {
                                    Text("LÅTAR")
                                        .font(.system(size: 11, weight: .black))
                                        .foregroundStyle(.orange)
                                        .padding(.horizontal)
                                        .padding(.top, 16)
                                        .padding(.bottom, 8)
                                    
                                    ForEach(viewModel.tracks) { track in
                                        NavigationLink(destination: SearchTrackDetailView(track: track)) {
                                            SearchTrackRowView(track: track)
                                        }
                                        .buttonStyle(.plain)
                                        .padding(.horizontal)
                                        .padding(.bottom, 8)
                                    }
                                }
                                
                                if viewModel.artists.isEmpty && viewModel.tracks.isEmpty {
                                    VStack(spacing: 12) {
                                        Text("😕")
                                            .font(.system(size: 50))
                                        Text("Inga resultat för \"\(searchText)\"")
                                            .foregroundStyle(.white)
                                            .font(.headline)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 80)
                                }
                            }
                            .padding(.bottom, 20)
                        }
                    }
                }
            }
            .navigationTitle("Sök 🔍")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Artist, låt...")
            .preferredColorScheme(.dark)
            .onChange(of: searchText) { _, newValue in
                searchTask?.cancel()
                if newValue.isEmpty {
                    viewModel.tracks = []
                    viewModel.artists = []
                    viewModel.hasSearched = false
                    return
                }
                searchTask = Task {
                    try? await Task.sleep(nanoseconds: 600_000_000)
                    if !Task.isCancelled {
                        await viewModel.search(query: newValue)
                        if !newValue.isEmpty {
                            addToHistory(newValue)
                        }
                    }
                }
            }
        }
    }
}
