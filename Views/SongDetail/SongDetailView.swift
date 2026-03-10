import SwiftUI
import SwiftData

struct SongDetailView: View {
    let track: Track
    @StateObject private var savedViewModel = SavedViewModel()
    @Environment(\.modelContext) private var context
    @Query private var savedSongs: [SavedSong]
    
    var isSaved: Bool {
        savedSongs.contains(where: { $0.name == track.name })
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(LinearGradient(
                                colors: [.purple.opacity(0.6), .blue.opacity(0.4)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing))
                            .frame(width: 200, height: 200)
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
                        
                        NavigationLink(destination: ArtistView(artistName: track.artist.name)) {
                            Text(track.artist.name)
                                .font(.headline)
                                .foregroundStyle(.orange)
                        }
                    }
                    
                    HStack(spacing: 40) {
                        VStack {
                            Text(formatPlaycount(track.playcount))
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(.orange)
                            Text("Streams")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                    }
                    
                    Button {
                        if !isSaved {
                            savedViewModel.saveSong(track, context: context)
                        }
                    } label: {
                        HStack {
                            Image(systemName: isSaved ? "heart.fill" : "heart")
                            Text(isSaved ? "Sparad" : "Spara låt")
                        }
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isSaved ? Color.gray : Color.orange)
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
    
    func formatPlaycount(_ count: String) -> String {
        guard let number = Int(count) else { return count }
        if number >= 1_000_000 {
            return String(format: "%.1fM", Double(number) / 1_000_000)
        }
        return "\(number)"
    }
}
