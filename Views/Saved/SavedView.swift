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
            
            if savedSongs.isEmpty {
                VStack(spacing: 16) {
                    Text("🎵")
                        .font(.system(size: 60))
                    Text("Inga sparade låtar ännu")
                        .font(.headline)
                        .foregroundStyle(.white)
                    Text("Gå till Trending och spara dina favoriter!")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            } else {
                List {
                    Section {
                        ForEach(savedSongs) { song in
                            HStack(spacing: 12) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.purple.opacity(0.3))
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
                    
                    if !savedArtists.isEmpty {
                        Section {
                            ForEach(savedArtists) { artist in
                                NavigationLink(destination: ArtistView(artistName: artist.name)) {
                                    HStack(spacing: 12) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.orange.opacity(0.3))
                                                .frame(width: 44, height: 44)
                                            Text("🎤")
                                                .font(.title3)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(artist.name)
                                                .font(.headline)
                                                .foregroundStyle(.white)
                                            Text("\(artist.songs.count) sparade låtar")
                                                .font(.subheadline)
                                                .foregroundStyle(.gray)
                                        }
                                    }
                                }
                                .listRowBackground(Color.white.opacity(0.05))
                            }
                        } header: {
                            Text("Artister")
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
    }
}
