import Foundation
import SwiftData
import Combine

class SavedViewModel: ObservableObject {
    
    func saveSong(_ track: Track, context: ModelContext) {
        let existing = try? context.fetch(FetchDescriptor<SavedSong>())
        if existing?.contains(where: { $0.name == track.name }) == true {
            return
        }
        
        let artists = try? context.fetch(FetchDescriptor<SavedArtist>())
        let existingArtist = artists?.first(where: { $0.name == track.artist.name })
        
        let artist = existingArtist ?? SavedArtist(name: track.artist.name, artistURL: track.artist.url)
        if existingArtist == nil {
            context.insert(artist)
        }
        
        let song = SavedSong(
            name: track.name,
            artistName: track.artist.name,
            playcount: track.playcount,
            trackURL: track.url
        )
        song.artist = artist
        artist.songs.append(song)
        context.insert(song)
    }
    
    func deleteSong(_ song: SavedSong, context: ModelContext) {
        context.delete(song)
    }
}
