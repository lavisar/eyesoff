import Cocoa
import ServiceManagement

class MenuBarManager: MenuBarManagerProtocol {
    weak var delegate: MenuBarManagerDelegate?
    
    private var statusItem: NSStatusItem!
    private var soundMenu: NSMenu!
    private let soundManager: SoundManagerProtocol
    
    private var lang: LocalizedStrings {
        AppLanguage.current.localizedStrings
    }
    
    init(soundManager: SoundManagerProtocol) {
        self.soundManager = soundManager
    }
    
    func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.title = "👁️"
        
        let menu = NSMenu()
        
        // Sound menu
        setupSoundMenu(in: menu)
        
        // Language menu
        menu.addItem(setupLanguageMenu())
        
        // Login item
        setupLoginItem(in: menu)
        
        // Settings and info
        setupSettingsAndInfo(in: menu)
        
        statusItem.menu = menu
    }
    
    func updateMenuBar() {
        setupMenuBar()
    }
    
    // MARK: - Private Methods
    
    private func setupSoundMenu(in menu: NSMenu) {
        soundMenu = NSMenu()
        let sounds = soundManager.getSystemSoundNames()
        let currentSound = soundManager.getSelectedSound()

        for sound in sounds {
            let menuItem = NSMenuItem()
            let button = NSButton(radioButtonWithTitle: sound, target: self, action: #selector(selectSoundRadio(_:)))
            button.identifier = NSUserInterfaceItemIdentifier(rawValue: sound)
            button.state = (sound == currentSound) ? .on : .off
            menuItem.view = button
            soundMenu.addItem(menuItem)
        }

        let soundMenuItem = NSMenuItem(title: lang.selectSound, action: nil, keyEquivalent: "")
        menu.setSubmenu(soundMenu, for: soundMenuItem)
        menu.addItem(soundMenuItem)
    }
    
    private func setupLanguageMenu() -> NSMenuItem {
        let langMenu = NSMenu()
        for lang in AppLanguage.allCases {
            let item = NSMenuItem(title: lang.rawValue, action: #selector(selectLanguage(_:)), keyEquivalent: "")
            item.state = (lang == AppLanguage.current) ? .on : .off
            langMenu.addItem(item)
        }
        let parentItem = NSMenuItem(title: lang.language, action: nil, keyEquivalent: "")
        parentItem.submenu = langMenu
        return parentItem
    }
    
    private func setupLoginItem(in menu: NSMenu) {
        let loginItem = NSMenuItem(title: lang.launchAtLogin, action: #selector(toggleLoginItem(_:)), keyEquivalent: "")
        loginItem.state = SMAppService.mainApp.status == .enabled ? .on : .off
        menu.addItem(loginItem)
    }
    
    private func setupSettingsAndInfo(in menu: NSMenu) {
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: lang.notificationSettings, action: #selector(openNotificationSettings), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: lang.aboutMenu, action: #selector(showAbout), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        
        let bugReportItem = NSMenuItem(title: lang.reportBug, action: #selector(sendBugReportEmail), keyEquivalent: "")
        menu.addItem(bugReportItem)
        
        menu.addItem(NSMenuItem(title: lang.quit, action: #selector(quitApp), keyEquivalent: "q"))
    }
    
    // MARK: - Actions
    
    @objc private func selectSoundRadio(_ sender: NSButton) {
        guard let sound = sender.identifier?.rawValue else { return }
        delegate?.menuBarDidSelectSound(sound)
        
        for item in soundMenu.items {
            if let btn = item.view as? NSButton {
                btn.state = (btn == sender) ? .on : .off
            }
        }
    }
    
    @objc private func selectLanguage(_ sender: NSMenuItem) {
        delegate?.menuBarDidSelectLanguage(sender.title)
    }
    
    @objc private func toggleLoginItem(_ sender: NSMenuItem) {
        let enable = sender.state == .off
        delegate?.menuBarDidToggleLoginItem(enable)
        sender.state = enable ? .on : .off
    }
    
    @objc private func openNotificationSettings() {
        delegate?.menuBarDidRequestNotificationSettings()
    }
    
    @objc private func showAbout() {
        delegate?.menuBarDidRequestAbout()
    }
    
    @objc private func sendBugReportEmail() {
        delegate?.menuBarDidRequestBugReport()
    }
    
    @objc private func quitApp() {
        delegate?.menuBarDidRequestQuit()
    }
}
