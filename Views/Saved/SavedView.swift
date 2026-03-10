import SwiftUI
import SwiftData

struct SavedView: View {
    @Environment(\.modelContext) private var context
    @Query private var savedSongs: [SavedSong]
    @Query private var savedArtists: [SavedArtist]
    @StateObject private var viewModel = SavedViewModel()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if savedSongs.isEmpty && savedArtists.isEmpty {
                VStack(spacing: 16) {
                    Text("🎵")
                        .font(.system(size: 60))
                    Text("Inga sparade än")
                        .font(.headline)
                        .foregroundStyle(.white)
                    Text("Gå till Trending eller Sök och spara dina favoriter!")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            } else {
                List {
                    if !savedSongs.isEmpty {
                        Section {
                            ForEach(savedSongs) { song in
                                HStack(spacing: 12) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(LinearGradient(
                                                colors: [.purple.opacity(0.6), .blue.opacity(0.4)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing))
                                            .frame(width: 44, height: 44)
                                        Text("🎵")
                                            .font(.title3)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(song.name)
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                            .lineLimit(1)
                                        Text(song.artistName)
                                            .font(.subheadline)
                                            .foregroundStyle(.gray)
                                            .lineLimit(1)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "heart.fill")
                                        .foregroundStyle(.orange)
                                }
                                .listRowBackground(Color.white.opacity(0.05))
                            }
                            .onDelete { indexSet in
                                for index in indexSet {
                                    viewModel.deleteSong(savedSongs[index], context: context)
                                }
                            }
                        } header: {
                            Text("Sparade låtar")
                                .foregroundStyle(.orange)
                        }
                    }
                    
                    if !savedArtists.isEmpty {
                        Section {
                            ForEach(savedArtists) { artist in
                                NavigationLink(destination: ArtistView(artistName: artist.name)) {
                                    HStack(spacing: 12) {
                                        ZStack {
                                            Circle()
                                                .fill(LinearGradient(
                                                    colors: [.orange.opacity(0.6), .purple.opacity(0.4)],
                                                    startPoint: .top,
                                                    endPoint: .bottom))
                                                .frame(width: 44, height: 44)
                                            Text("🎤")
                                                .font(.title3)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(artist.name)
                                                .font(.headline)
                                                .foregroundStyle(.white)
                                            Text(artist.songs.isEmpty ? "Sparad artist" : "\(artist.songs.count) sparade låtar")
                                                .font(.subheadline)
                                                .foregroundStyle(.gray)
                                        }
                                    }
                                }
                                .listRowBackground(Color.white.opacity(0.05))
                            }
                            .onDelete { indexSet in
                                for index in indexSet {
                                    context.delete(savedArtists[index])
                                }
                            }
                        } header: {
                            Text("Sparade artister")
                                .foregroundStyle(.orange)
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
            }
        }
        .navigationTitle("Sparade ❤️")
        .navigationBarTitleDisplayMode(.large)
        .preferredColorScheme(.dark)
        .toolbar {
            EditButton()
                .foregroundStyle(.orange)
        }
    }
}
