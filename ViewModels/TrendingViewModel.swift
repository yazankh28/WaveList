import Foundation
import Combine


@MainActor
class TrendingViewModel: ObservableObject {
    @Published var tracks: [Track] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchTracks() async {
        isLoading = true
        errorMessage = nil
        
        do {
            tracks = try await MusicService.shared.fetchTopTracks()
        } catch {
            errorMessage = "Kunde inte hämta låtar. Försök igen."
        }
        
        isLoading = false
    }
}
