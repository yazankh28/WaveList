import SwiftUI

struct TrackRowView: View {
    let track: Track
    let rank: Int
    
    var rankColor: Color {
        switch rank {
        case 1: return .yellow
        case 2: return .gray
        case 3: return Color.orange
        default: return Color.white.opacity(0.3)
        }
    }
    
    var body: some View {
        HStack(spacing: 14) {
            Text("\(rank)")
                .font(.system(size: 14, weight: .black))
                .foregroundStyle(rankColor)
                .frame(width: 24)
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(LinearGradient(
                        colors: [Color.purple.opacity(0.6), Color.blue.opacity(0.4)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing))
                    .frame(width: 46, height: 46)
                Text("🎵")
                    .font(.system(size: 20))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(track.name)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                Text(track.artist.name)
                    .font(.system(size: 12))
                    .foregroundStyle(.gray)
                    .lineLimit(1)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(formatPlaycount(track.playcount))
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.orange)
                Text("streams")
                    .font(.system(size: 9))
                    .foregroundStyle(.gray)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.white.opacity(0.05))
        .cornerRadius(14)
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
