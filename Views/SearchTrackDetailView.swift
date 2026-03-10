import SwiftUI
import SwiftData

struct SearchTrackDetailView: View {
    let track: SearchTrack
    @Environment(\.modelContext) private var context
    @Query private var savedSongs: [SavedSong]
    @StateObject private var savedViewModel = SavedViewModel()
    
    var isSaved: Bool {
        savedSongs.contains(where: { $0.name == track.name })
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
                            Text(track.artist)
                                .font(.headline)
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
                    
                    Button {
                        if !isSaved {
                            let t = Track(name: track.name,
                                        artist: Artist(name: track.artist, url: track.url),
                                        playcount: track.listeners,
                                        url: track.url)
                            savedViewModel.saveSong(t, context: context)
                        }
                    } label: {
                        HStack {
                            Image(systemName: isSaved ? "heart.fill" : "heart")
                            Text(isSaved ? "Sparad ✓" : "Spara låt")
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
