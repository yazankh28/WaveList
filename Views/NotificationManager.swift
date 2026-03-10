import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    var isAuthorized = false
    
    func requestPermission() async {
        do {
            let granted = try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .badge, .sound])
            isAuthorized = granted
        } catch {
            print("Notification error: \(error)")
        }
    }
    
    func checkPermission() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        isAuthorized = settings.authorizationStatus == .authorized
    }
    
    func scheduleNewChartNotification(trackName: String, artistName: String) {
        let content = UNMutableNotificationContent()
        content.title = "🔥 Ny #1 på Trending!"
        content.body = "\(trackName) av \(artistName) toppar listan!"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "newChart", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
