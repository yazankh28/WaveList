import Foundation

struct ArtistInfoResponse: Codable {
    let artist: ArtistInfo
}

struct ArtistInfo: Codable {
    let name: String
    let url: String
    let stats: ArtistStats
    let bio: ArtistBio
}

struct ArtistStats: Codable {
    let listeners: String
    let playcount: String
}

struct ArtistBio: Codable {
    let summary: String
}
