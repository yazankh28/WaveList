import Foundation
import SwiftData

@Model
class SavedArtist {
    var name: String
    var artistURL: String
    var savedAt: Date
    
    @Relationship(deleteRule: .cascade)
    var songs: [SavedSong]
    
    init(name: String, artistURL: String) {
        self.name = name
        self.artistURL = artistURL
        self.savedAt = Date()
        self.songs = []
    }
}
