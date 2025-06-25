import UserNotifications
import Cocoa

class NotificationManager: NotificationManagerProtocol {
    weak var delegate: NotificationManagerDelegate?
    
    private var lang: LocalizedStrings {
        AppLanguage.current.localizedStrings
    }
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { [weak self] granted, _ in
            DispatchQueue.main.async {
                self?.delegate?.notificationPermissionGranted(granted)
            }
            if !granted {
                print("⚠️ Notification permission not granted.")
            }
        }
    }
    
    func sendBackToWorkNotification() {
        let content = UNMutableNotificationContent()
        content.title = lang.backToWorkTitle
        content.body = lang.backToWorkBody
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to send notification: \(error)")
            }
        }
    }
    
    func openNotificationSettings() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.notifications") {
            NSWorkspace.shared.open(url)
        }
    }
}
