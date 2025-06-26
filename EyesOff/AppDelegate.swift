import Cocoa
import UserNotifications
import ServiceManagement
import Foundation


class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var statusBarText: String? {
        didSet {
            updateStatusItem()
        }
    }
    var workTimer: Timer?
    var countdownTimer: Timer?
    var remainingSeconds = 20
    var currentInterval: TimeInterval = 1 * 60 // 20 minutes
    var isBreakAlertRunning = false
    var soundMenu: NSMenu!
    var ignoreListWindow: NSWindow?

    var lang: LocalizedStrings {
        AppLanguage.current.localizedStrings
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenuBar()
        requestNotificationPermission()
        startWorkTimer()
        analysisInstallTime()
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
        
        //? Ignore list
        menu.addItem(NSMenuItem(title: lang.ignoreList, action: #selector(openIgnoreList), keyEquivalent: ""))

        //? App info
        menu.addItem(NSMenuItem(title: lang.aboutMenu, action: #selector(showAbout), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        
        //? Bug report
        let bugReportItem = NSMenuItem(title: lang.reportBug, action: #selector(sendBugReportEmail), keyEquivalent: "")
        menu.addItem(bugReportItem)
        
        menu.addItem(NSMenuItem(title: lang.quit, action: #selector(quitApp), keyEquivalent: "q"))
        statusItem.menu = menu
        updateStatusItem()
    }

    func updateStatusItem() {
        if let text = statusBarText {
            statusItem.button?.title = "\u{1F441}\u{FE0F} \(text)"
        } else {
            statusItem.button?.title = "\u{1F441}\u{FE0F}"
        }
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
        guard let frontmostApp = NSWorkspace.shared.frontmostApplication,
              let bundleIdentifier = frontmostApp.bundleIdentifier else {
            // If we can't get the frontmost app, show the alert by default
            showBreakAlertWithCountdown()
            return
        }

        let ignoredApps = UserDefaults.standard.stringArray(forKey: "IgnoredApps") ?? []
        if ignoredApps.contains(bundleIdentifier) {
            print("> App is in ignore list, skipping break reminder.")
            return
        }

        showBreakAlertWithCountdown()
    }
    
    func showBreakAlertWithCountdown() {
        print("> Break alert is showing...")
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
            self.statusBarText = "You should break now in \(self.remainingSeconds)s"
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
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to send notification: \(error)")
            }
        }
        self.statusBarText = "You can back to work now"
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.statusBarText = nil
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
    
    // 🙌 We collect anonymous stats (lang, OS, version) to improve EyesOff — no personal info, ever.
    func analysisInstallTime() {
        let launchedKey = "EyesOff-Analysis"

        guard !UserDefaults.standard.bool(forKey: launchedKey) else {
            return
        }

        UserDefaults.standard.set(true, forKey: launchedKey)
        print("📍 First launch detected. Sending anonymous install ping...")

        guard let url = URL(string: "https://eyesoff.vercel.app/api/install") else {
            print("❌ Invalid analytics URL")
            return
        }
        //? Request body
        let payload: [String: String] = [
            "lang": Locale.current.identifier,
            "os": ProcessInfo.processInfo.operatingSystemVersionString,
            "version": VERSION_INFO
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        } catch {
            print("❌ Failed to encode analytics payload: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("⚠️ Install ping failed: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("📤 Anonymous install ping sent ✅ [HTTP \(httpResponse.statusCode)]")
            }
        }.resume()
    }

    @objc func sendBugReportEmail() {
        let body = """
        Hi Lavisar,
        I found a bug in EyesOff.
        
        [Describe the issue here]
        
        App Version: \(VERSION_INFO)
        System: \(ProcessInfo.processInfo.operatingSystemVersionString)
        """

        let email = "https://mail.google.com/mail/?view=cm&fs=1&to=lavisar.dev@gmail.com&su=EyesOff_Bug_Report&body=\(body)"

        if let url = URL(string: email) {
            NSWorkspace.shared.open(url)
        }
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
    
    @objc func openIgnoreList() {
        if ignoreListWindow == nil {
            let viewController = IgnoreListViewController()
            viewController.appDelegate = self
            
            let window = NSWindow(contentViewController: viewController)
            window.title = lang.ignoreList
            window.styleMask = [.titled, .closable, .miniaturizable]
            window.isReleasedWhenClosed = false // Important: Keep the window instance
            
            ignoreListWindow = window
        }
        
        ignoreListWindow?.center()
        ignoreListWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
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
