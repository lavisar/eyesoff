import Foundation

protocol NotificationManagerDelegate: AnyObject {
    func notificationPermissionGranted(_ granted: Bool)
}

protocol NotificationManagerProtocol {
    var delegate: NotificationManagerDelegate? { get set }
    
    func requestPermission()
    func sendBackToWorkNotification()
    func openNotificationSettings()
}
