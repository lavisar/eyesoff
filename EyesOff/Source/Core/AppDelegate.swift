import Cocoa
import UserNotifications

class AppDelegate: NSObject, NSApplicationDelegate {
    // MARK: - Dependencies
    private lazy var timerManager: TimerManagerProtocol = {
        let manager = TimerManager()
        manager.delegate = self
        return manager
    }()
    
    private lazy var soundManager: SoundManagerProtocol = SoundManager()
    
    private lazy var notificationManager: NotificationManagerProtocol = {
        let manager = NotificationManager()
        manager.delegate = self
        return manager
    }()
    
    private lazy var menuBarManager: MenuBarManagerProtocol = {
        let manager = MenuBarManager(soundManager: soundManager)
        manager.delegate = self
        return manager
    }()
    
    private lazy var settingsManager: SettingsManagerProtocol = SettingsManager()
    private lazy var analyticsManager: AnalyticsManagerProtocol = AnalyticsManager()
    
    // MARK: - Application Lifecycle
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        menuBarManager.setupMenuBar()
        notificationManager.requestPermission()
        timerManager.startWorkTimer()
        analyticsManager.trackInstallIfNeeded()
    }
}

// MARK: - Timer Manager Delegate

extension AppDelegate: TimerManagerDelegate {
    func timerDidTriggerBreakReminder() {
        DispatchQueue.main.async {
            self.showBreakAlert()
            self.soundManager.playSelectedSound()
            self.timerManager.startBreakCountdown()
        }
    }
    
    func timerDidFinishBreakCountdown() {
        notificationManager.sendBackToWorkNotification()
        timerManager.startWorkTimer()
    }
    
    private func showBreakAlert() {
        let lang = AppLanguage.current.localizedStrings
        let alert = NSAlert()
        alert.messageText = lang.breakTitle
        alert.informativeText = lang.breakBody
        alert.alertStyle = .informational
        alert.addButton(withTitle: lang.breakButton)
        alert.runModal()
    }
}

// MARK: - MenuBar Manager Delegate

extension AppDelegate: MenuBarManagerDelegate {
    func menuBarDidSelectSound(_ sound: String) {
        soundManager.saveSelectedSound(sound)
        soundManager.playSelectedSound()
    }
    
    func menuBarDidSelectLanguage(_ language: String) {
        UserDefaultsHelper.shared.set(language, forKey: AppConstants.UserDefaultsKeys.appLanguage)
        menuBarManager.updateMenuBar()
    }
    
    func menuBarDidToggleLoginItem(_ enabled: Bool) {
        _ = settingsManager.toggleLaunchAtLogin(enabled)
    }
    
    func menuBarDidRequestNotificationSettings() {
        notificationManager.openNotificationSettings()
    }
    
    func menuBarDidRequestAbout() {
        settingsManager.showAboutDialog()
    }
    
    func menuBarDidRequestBugReport() {
        settingsManager.openBugReportEmail()
    }
    
    func menuBarDidRequestQuit() {
        NSApplication.shared.terminate(self)
    }
}

// MARK: - Notification Manager Delegate

extension AppDelegate: NotificationManagerDelegate {
    func notificationPermissionGranted(_ granted: Bool) {
        if !granted {
            print("⚠️ Notification permission not granted")
        }
    }
}
