import SwiftUI

struct TrackRowView: View {
    let track: Track
    let rank: Int
    
    var body: some View {
        HStack(spacing: 12) {
            Text("\(rank)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(rank <= 3 ? .orange : .gray)
                .frame(width: 28)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(track.name)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                Text(track.artist.name)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Text(formatPlaycount(track.playcount))
                .font(.caption)
                .foregroundStyle(.gray)
        }
        .padding(.vertical, 6)
    }
    
    func formatPlaycount(_ count: String) -> String {
        guard let number = Int(count) else { return count }
        if number >= 1_000_000 {
            return String(format: "%.1fM", Double(number) / 1_000_000)
        } else if number >= 1_000 {
            return String(format: "%.0fK", Double(number) / 1_000)
        }
        return "\(number)"
    }
}
