
import SwiftUI

struct ArtistRowView: View {
    let artist: ArtistSearchResult
    
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [Color.orange.opacity(0.6), Color.purple.opacity(0.4)],
                        startPoint: .top,
                        endPoint: .bottom))
                    .frame(width: 46, height: 46)
                Text("🎤")
                    .font(.system(size: 20))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(artist.name)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)
                Text(formatListeners(artist.listeners))
                    .font(.system(size: 12))
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.gray)
                .font(.system(size: 12))
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.white.opacity(0.05))
        .cornerRadius(14)
    }
    
    func formatListeners(_ count: String) -> String {
        guard let number = Int(count) else { return "\(count) lyssnare" }
        if number >= 1_000_000 {
            return String(format: "%.1fM lyssnare", Double(number) / 1_000_000)
        } else if number >= 1_000 {
            return String(format: "%.0fK lyssnare", Double(number) / 1_000)
        }
        return "\(number) lyssnare"
    }
}
