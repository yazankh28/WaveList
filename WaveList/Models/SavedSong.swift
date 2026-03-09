import Foundation
import SwiftData

@Model
class SavedSong {
    var name: String
    var artistName: String
    var playcount: String
    var trackURL: String
    var savedAt: Date
    
    @Relationship(deleteRule: .nullify)
    var artist: SavedArtist?
    
    init(name: String, artistName: String, playcount: String, trackURL: String) {
        self.name = name
        self.artistName = artistName
        self.playcount = playcount
        self.trackURL = trackURL
        self.savedAt = Date()
    }
}
