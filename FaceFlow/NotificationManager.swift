import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()
    private init() {}

    func requestAuthorization() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound])
        } catch {
            return false
        }
    }

    func scheduleDailyReminder(at components: DateComponents) async {
        let content = UNMutableNotificationContent()
        content.title = "Your FaceFlow ritual is ready"
        content.body = "A few minutes is all you need today."
        content.sound = .default

        var date = DateComponents()
        date.hour = components.hour ?? 8
        date.minute = components.minute ?? 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: "faceflow.daily", content: content, trigger: trigger)

        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {}
    }

    func cancelReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["faceflow.daily"])
    }
}
