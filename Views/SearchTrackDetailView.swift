import SwiftUI
import SwiftData

struct SearchTrackDetailView: View {
    let track: SearchTrack
    @Environment(\.modelContext) private var context
    @Query private var savedSongs: [SavedSong]
    @StateObject private var savedViewModel = SavedViewModel()
    
    var isSaved: Bool {
        savedSongs.contains(where: { $0.name == track.name && $0.artistName == track.artist })
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(LinearGradient(
                                colors: [.purple.opacity(0.7), .blue.opacity(0.5)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing))
                            .frame(width: 200, height: 200)
                            .shadow(color: .purple.opacity(0.3), radius: 20)
                        Text("🎵")
                            .font(.system(size: 80))
                    }
                    .padding(.top)
                    
                    VStack(spacing: 8) {
                        Text(track.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                        
                        NavigationLink(destination: ArtistView(artistName: track.artist)) {
                            HStack(spacing: 4) {
                                Text("🎤")
                                Text(track.artist)
                                    .fontWeight(.semibold)
                            }
                            .foregroundStyle(.orange)
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack(spacing: 40) {
                        VStack(spacing: 4) {
                            Text(formatCount(track.listeners))
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(.orange)
                            Text("Lyssnare")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(16)
                    
                    // Spara-knapp
                    Button {
                        if isSaved {
                            // Ta bort
                            if let song = savedSongs.first(where: { $0.name == track.name && $0.artistName == track.artist }) {
                                savedViewModel.deleteSong(song, context: context)
                            }
                        } else {
                            // Spara
                            let artists = try? context.fetch(FetchDescriptor<SavedArtist>())
                            let existingArtist = artists?.first(where: { $0.name == track.artist })
                            
                            let artist = existingArtist ?? SavedArtist(name: track.artist, artistURL: track.url)
                            if existingArtist == nil {
                                context.insert(artist)
                            }
                            
                            let song = SavedSong(
                                name: track.name,
                                artistName: track.artist,
                                playcount: track.listeners,
                                trackURL: track.url
                            )
                            song.artist = artist
                            artist.songs.append(song)
                            context.insert(song)
                        }
                    } label: {
                        HStack {
                            Image(systemName: isSaved ? "heart.fill" : "heart")
                            Text(isSaved ? "Sparad – tryck för att ta bort" : "Spara låt")
                        }
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isSaved ? Color.gray : Color.orange)
                        .cornerRadius(14)
                        .padding(.horizontal)
                    }
                    
                    NavigationLink(destination: ArtistView(artistName: track.artist)) {
                        HStack {
                            Text("🎤")
                            Text("Se mer om \(track.artist)")
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(14)
                        .padding(.horizontal)
                    }
                    
                    Link("Öppna på Last.fm", destination: URL(string: track.url)!)
                        .foregroundStyle(.orange)
                        .padding(.bottom)
                }
            }
        }
        .navigationTitle(track.name)
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
    }
    
    func formatCount(_ count: String) -> String {
        guard let number = Int(count) else { return count }
        if number >= 1_000_000 {
            return String(format: "%.1fM", Double(number) / 1_000_000)
        } else if number >= 1_000 {
            return String(format: "%.0fK", Double(number) / 1_000)
        }
        return "\(number)"
    }
}
