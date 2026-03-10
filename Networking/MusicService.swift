import Foundation

class MusicService {
    static let shared = MusicService()
    
    private let apiKey = "c4b6d8f7e9a2b3c1d5e6f7a8b9c0d1e2"
    private let baseURL = "https://ws.audioscrobbler.com/2.0/"
    
    func fetchTopTracks() async throws -> [Track] {
        let urlString = "\(baseURL)?method=chart.gettoptracks&api_key=\(apiKey)&format=json&limit=20"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(TopTracksResponse.self, from: data)
        return response.tracks.track
    }
    
    func fetchArtistInfo(artistName: String) async throws -> ArtistInfo {
        let encoded = artistName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? artistName
        let urlString = "\(baseURL)?method=artist.getinfo&artist=\(encoded)&api_key=\(apiKey)&format=json"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(ArtistInfoResponse.self, from: data)
        return response.artist
    }
}
