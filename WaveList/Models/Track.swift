import Foundation

struct Track: Codable, Identifiable {
    let id = UUID()
    let name: String
    let artist: Artist
    let playcount: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case name, artist, playcount, url
    }
}

struct Artist: Codable {
    let name: String
    let url: String
}

struct TopTracksResponse: Codable {
    let tracks: TracksWrapper
}

struct TracksWrapper: Codable {
    let track: [Track]
}
