import Cocoa
import UserNotifications
import ServiceManagement
import Foundation


class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var workTimer: Timer?
    var countdownTimer: Timer?
    var remainingSeconds = 20
    var currentInterval: TimeInterval = 20 * 60 // 20 minutes
    var isBreakAlertRunning = false
    var soundMenu: NSMenu!
    
    var lang: LocalizedStrings {
        AppLanguage.current.localizedStrings
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenuBar()
        requestNotificationPermission()
        startWorkTimer()
    }

    func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.title = "\u{1F441}\u{FE0F}"

        let menu = NSMenu()
        soundMenu = NSMenu()
        let sounds = getSystemSoundNames()
        let currentSound = getSelectedSound()

        for sound in sounds {
            let menuItem = NSMenuItem()
            let button = NSButton(radioButtonWithTitle: sound, target: self, action: #selector(selectSoundRadio(_:)))
            button.identifier = NSUserInterfaceItemIdentifier(rawValue: sound)
            button.state = (sound == currentSound) ? .on : .off
            menuItem.view = button
            soundMenu.addItem(menuItem)
        }


        //? Sound customize
        let soundMenuItem = NSMenuItem(title: lang.selectSound, action: nil, keyEquivalent: "")
        menu.setSubmenu(soundMenu, for: soundMenuItem)
        menu.addItem(soundMenuItem)
        
        //? Language settings
        menu.addItem(setupLanguageMenu())
        
        //? Run on login
        let loginItem = NSMenuItem(title: lang.launchAtLogin, action: #selector(toggleLoginItem(_:)), keyEquivalent: "")
        loginItem.state = SMAppService.mainApp.status == .enabled ? .on : .off
        menu.addItem(loginItem)

        //? Noti setting
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: lang.notificationSettings, action: #selector(openNotificationSettings), keyEquivalent: ""))
        
        //? App info
        menu.addItem(NSMenuItem(title: lang.aboutMenu, action: #selector(showAbout), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: lang.quit, action: #selector(quitApp), keyEquivalent: "q"))
        statusItem.menu = menu
    }
    
    func setupLanguageMenu() -> NSMenuItem {
        let langMenu = NSMenu()
        for lang in AppLanguage.allCases {
            let item = NSMenuItem(title: lang.rawValue, action: #selector(selectLanguage(_:)), keyEquivalent: "")
            item.state = (lang == AppLanguage.current) ? .on : .off
            langMenu.addItem(item)
        }
        let parentItem = NSMenuItem(title: AppLanguage.current.localizedStrings.language, action: nil, keyEquivalent: "")
        parentItem.submenu = langMenu
        return parentItem
    }

    @objc func selectLanguage(_ sender: NSMenuItem) {
        UserDefaults.standard.set(sender.title, forKey: "AppLanguage")
        setupMenuBar()
    }
    
    func toggleLaunchAtLogin(_ enabled: Bool) {
        do {
            if enabled {
                try SMAppService.mainApp.register()
                print("✅ App registered for launch at login")
            } else {
                try SMAppService.mainApp.unregister()
                print("❌ App unregistered from launch at login")
            }
        } catch {
            print("⚠️ Failed to toggle launch at login: \(error)")
        }
    }


    func startWorkTimer() {
        workTimer?.invalidate()
        workTimer = Timer.scheduledTimer(withTimeInterval: currentInterval, repeats: true) { [weak self] _ in
            self?.triggerBreakReminder()
        }
    }

    func triggerBreakReminder() {
        DispatchQueue.main.async {
            self.remainingSeconds = 20
            self.showBreakAlert()
            self.playAlertSound()
            self.startCountdownToDismissAlert()
        }
    }

    func startCountdownToDismissAlert() {
        countdownTimer?.invalidate()
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.remainingSeconds -= 1
            if self.remainingSeconds <= 0 {
                timer.invalidate()
                self.sendBackToWorkNotification()
                self.startWorkTimer() // Restart 20 minutes
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
            trigger: nil // Gửi ngay
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to send notification: \(error)")
            }
        }
    }

    
    func showBreakAlert() {
        if isBreakAlertRunning {
            return
        }
        
        isBreakAlertRunning = true
        
        let alert = NSAlert()
        alert.messageText = lang.breakTitle
        alert.informativeText = lang.breakBody
        alert.alertStyle = .informational
        alert.addButton(withTitle: lang.breakButton)
        
        //? Cancel any previous scheduled alerts
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(showAlertModal(_:)), object: nil)
        
        self.perform(#selector(showAlertModal(_:)), with: alert, afterDelay: 0.1)
    }


    @objc func showAlertModal(_ alert: NSAlert) {
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            isBreakAlertRunning = false
        }
    }

    func playAlertSound() {
        let currentSound = getSelectedSound()
        NSSound(named: NSSound.Name(currentSound))?.play()
    }

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            if !granted {
                print("\u{2757} Notification permission not granted.")
            }
        }
    }
        
    //? Custom sound
    func getSystemSoundNames() -> [String] {
        let soundFolder = "/System/Library/Sounds"
        let fileManager = FileManager.default
        guard let items = try? fileManager.contentsOfDirectory(atPath: soundFolder) else { return [] }
        return items
            .filter { $0.hasSuffix(".aiff") }
            .map { $0.replacingOccurrences(of: ".aiff", with: "") }
    }

    func saveSelectedSound(_ name: String) {
        UserDefaults.standard.set(name, forKey: "SelectedSound")
    }

    func getSelectedSound() -> String {
        return UserDefaults.standard.string(forKey: "SelectedSound") ?? "Submarine"
    }

    func playSoundSelectSound() {
        let soundName = getSelectedSound()
        NSSound(named: NSSound.Name(soundName))?.play()
    }
    
    @objc func toggleLoginItem(_ sender: NSMenuItem) {
        let enable = sender.state == .off
        toggleLaunchAtLogin(enable)
        sender.state = enable ? .on : .off
    }
    
    @objc func selectSoundRadio(_ sender: NSButton) {
        guard let sound = sender.identifier?.rawValue else { return }
        saveSelectedSound(sound)
        playSoundSelectSound()

        for item in soundMenu.items {
            if let btn = item.view as? NSButton {
                btn.state = (btn == sender) ? .on : .off
            }
        }
    }
    
    @objc func selectSound(_ sender: NSMenuItem) {
        guard let selected = sender.representedObject as? String else { return }
        saveSelectedSound(selected)
        playSoundSelectSound()

        sender.menu?.items.forEach { $0.state = .off }
        sender.state = .on

    }
    
    @objc func openNotificationSettings() {
            if let url = URL(string: "x-apple.systempreferences:com.apple.preference.notifications") {
                NSWorkspace.shared.open(url)
            }
        }

    @objc func dismissAlertManually() {
        countdownTimer?.invalidate()
        startWorkTimer()
    }

    @objc func showAbout() {
        let alert = NSAlert()
        alert.messageText = lang.aboutTitle
        alert.informativeText = lang.aboutBody
        alert.alertStyle = .informational
        alert.runModal()
    }

    @objc func quitApp() {
        NSApplication.shared.terminate(self)
    }
}
