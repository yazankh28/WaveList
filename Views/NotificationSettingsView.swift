import SwiftUI

struct NotificationSettingsView: View {
    @State private var isAuthorized = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            colors: [.orange.opacity(0.3), .purple.opacity(0.2)],
                            startPoint: .top,
                            endPoint: .bottom))
                        .frame(width: 120, height: 120)
                    Text("🔔")
                        .font(.system(size: 55))
                }
                
                VStack(spacing: 8) {
                    Text("Håll koll på trender!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    Text("Få en notis när en ny låt toppar Trending-listan")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                if isAuthorized {
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                            Text("Notiser är aktiverade!")
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                        }
                        
                        Button {
                            NotificationManager.shared.scheduleNewChartNotification(
                                trackName: "Espresso",
                                artistName: "Sabrina Carpenter"
                            )
                        } label: {
                            HStack {
                                Image(systemName: "bell.fill")
                                Text("Testa en notis")
                            }
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(14)
                            .padding(.horizontal)
                        }
                    }
                } else {
                    Button {
                        Task {
                            await NotificationManager.shared.requestPermission()
                            await checkStatus()
                        }
                    } label: {
                        HStack {
                            Image(systemName: "bell.fill")
                            Text("Aktivera notiser")
                        }
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(14)
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
        }
        .navigationTitle("Notiser 🔔")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        .task {
            await checkStatus()
        }
    }
    
    func checkStatus() async {
        await NotificationManager.shared.checkPermission()
        isAuthorized = NotificationManager.shared.isAuthorized
    }
}
