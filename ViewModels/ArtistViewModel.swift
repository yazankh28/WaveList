import Foundation
import Combine

@MainActor
class ArtistViewModel: ObservableObject {
    @Published var artistInfo: ArtistInfo?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchArtist(name: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            artistInfo = try await MusicService.shared.fetchArtistInfo(artistName: name)
        } catch {
            errorMessage = "Kunde inte hämta artistinfo."
        }
        
        isLoading = false
    }
}
