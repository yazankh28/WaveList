import Foundation

// Track Search
struct TrackSearchResponse: Codable {
    let results: TrackSearchResults
}

struct TrackSearchResults: Codable {
    let trackmatches: TrackMatches
}

struct TrackMatches: Codable {
    let track: [SearchTrack]
}

struct SearchTrack: Codable, Identifiable {
    let id = UUID()
    let name: String
    let artist: String
    let url: String
    let listeners: String
    
    enum CodingKeys: String, CodingKey {
        case name, artist, url, listeners
    }
}

// Artist Search
struct ArtistSearchResponse: Codable {
    let results: ArtistSearchResults
}

struct ArtistSearchResults: Codable {
    let artistmatches: ArtistMatches
}

struct ArtistMatches: Codable {
    let artist: [ArtistSearchResult]
}

struct ArtistSearchResult: Codable, Identifiable {
    let id = UUID()
    let name: String
    let url: String
    let listeners: String
    
    enum CodingKeys: String, CodingKey {
        case name, url, listeners
    }
}

// Track Info
struct TrackInfoResponse: Codable {
    let track: TrackInfo
}

struct TrackInfo: Codable {
    let name: String
    let url: String
    let duration: String?
    let playcount: String?
    let listeners: String?
    let artist: TrackArtist
    let wiki: TrackWiki?
}

struct TrackArtist: Codable {
    let name: String
    let url: String
}

struct TrackWiki: Codable {
    let summary: String
}
