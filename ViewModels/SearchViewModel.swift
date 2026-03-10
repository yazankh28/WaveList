import Foundation
import Combine 
class SearchViewModel: ObservableObject {
    @Published var tracks: [SearchTrack] = []
    @Published var artists: [ArtistSearchResult] = []
    @Published var isLoading = false
    @Published var hasSearched = false
    
    private var searchTask: Task<Void, Never>?
    
    func search(query: String) async {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            tracks = []
            artists = []
            hasSearched = false
            return
        }
        
        await MainActor.run {
            isLoading = true
            hasSearched = true
        }
        
        do {
            async let tracksResult = MusicService.shared.searchTracks(query: query)
            async let artistsResult = MusicService.shared.searchArtists(query: query)
            let (t, a) = try await (tracksResult, artistsResult)
            await MainActor.run {
                tracks = t
                artists = a
                isLoading = false
            }
        } catch {
            await MainActor.run {
                isLoading = false
            }
        }
    }
}
