import SwiftUI

struct ArtistView: View {
    let artistName: String
    @StateObject private var viewModel = ArtistViewModel()
    
    var body: some View {
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
                        Task { await viewModel.fetchArtist(name: artistName) }
                    }
                    .foregroundStyle(.orange)
                }
            } else if let artist = viewModel.artistInfo {
                ScrollView {
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(
                                    colors: [.orange.opacity(0.6), .purple.opacity(0.4)],
                                    startPoint: .top,
                                    endPoint: .bottom))
                                .frame(width: 120, height: 120)
                            Text("🎤")
                                .font(.system(size: 50))
                        }
                        .padding(.top)
                        
                        Text(artist.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        
                        HStack(spacing: 40) {
                            VStack {
                                Text(formatCount(artist.stats.listeners))
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.orange)
                                Text("Lyssnare")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                            VStack {
                                Text(formatCount(artist.stats.playcount))
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.orange)
                                Text("Streams")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(14)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Om artisten")
                                .font(.headline)
                                .foregroundStyle(.white)
                            
                            Text(cleanBio(artist.bio.summary))
                                .font(.body)
                                .foregroundStyle(.gray)
                                .lineLimit(6)
                        }
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(14)
                        .padding(.horizontal)
                        
                        Link("Öppna på Last.fm", destination: URL(string: artist.url)!)
                            .foregroundStyle(.orange)
                            .padding(.bottom)
                    }
                }
            }
        }
        .navigationTitle(artistName)
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        .task {
            await viewModel.fetchArtist(name: artistName)
        }
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
    
    func cleanBio(_ bio: String) -> String {
        if let range = bio.range(of: "<a href") {
            return String(bio[..<range.lowerBound]).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return bio
    }
}
