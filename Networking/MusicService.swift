import Foundation

class MusicService {
    static let shared = MusicService()
    
    private let apiKey = "8bc35f9d6ab87c0739ba53fea2de21b0"
    private let baseURL = "https://ws.audioscrobbler.com/2.0/"
    
    func fetchTopTracks() async throws -> [Track] {
        let urlString = "\(baseURL)?method=chart.gettoptracks&api_key=\(apiKey)&format=json&limit=20"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(TopTracksResponse.self, from: data)
        return response.tracks.track
    }
    
    func searchTracks(query: String) async throws -> [SearchTrack] {
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let urlString = "\(baseURL)?method=track.search&track=\(encoded)&api_key=\(apiKey)&format=json&limit=20"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(TrackSearchResponse.self, from: data)
        return response.results.trackmatches.track
    }
    
    func searchArtists(query: String) async throws -> [ArtistSearchResult] {
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let urlString = "\(baseURL)?method=artist.search&artist=\(encoded)&api_key=\(apiKey)&format=json&limit=10"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(ArtistSearchResponse.self, from: data)
        return response.results.artistmatches.artist
    }
    
    func fetchArtistInfo(artistName: String) async throws -> ArtistInfo {
        let encoded = artistName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? artistName
        let urlString = "\(baseURL)?method=artist.getinfo&artist=\(encoded)&api_key=\(apiKey)&format=json"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(ArtistInfoResponse.self, from: data)
        return response.artist
    }
    
    func fetchTrackInfo(trackName: String, artistName: String) async throws -> TrackInfo {
        let encodedTrack = trackName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? trackName
        let encodedArtist = artistName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? artistName
        let urlString = "\(baseURL)?method=track.getInfo&track=\(encodedTrack)&artist=\(encodedArtist)&api_key=\(apiKey)&format=json"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(TrackInfoResponse.self, from: data)
        return response.track
    }
}
