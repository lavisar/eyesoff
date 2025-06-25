import ServiceManagement
import Cocoa

class SettingsManager: SettingsManagerProtocol {
    private let userDefaults: UserDefaultsHelper
    
    init(userDefaults: UserDefaultsHelper = UserDefaultsHelper.shared) {
        self.userDefaults = userDefaults
    }
    
    func toggleLaunchAtLogin(_ enabled: Bool) -> Bool {
        do {
            if enabled {
                try SMAppService.mainApp.register()
                print("✅ App registered for launch at login")
            } else {
                try SMAppService.mainApp.unregister()
                print("❌ App unregistered from launch at login")
            }
            return true
        } catch {
            print("⚠️ Failed to toggle launch at login: \(error)")
            return false
        }
    }
    
    func showAboutDialog() {
        let lang = AppLanguage.current.localizedStrings
        let alert = NSAlert()
        alert.messageText = lang.aboutTitle
        alert.informativeText = lang.aboutBody
        alert.alertStyle = .informational
        alert.runModal()
    }
    
    func openBugReportEmail() {
        let body = """
        Hi Lavisar,
        I found a bug in EyesOff.
        
        [Describe the issue here]
        
        App Version: \(VERSION_INFO)
        System: \(ProcessInfo.processInfo.operatingSystemVersionString)
        """

        let email = "https://mail.google.com/mail/?view=cm&fs=1&to=\(AppConstants.bugReportEmail)&su=EyesOff_Bug_Report&body=\(body)"

        if let url = URL(string: email) {
            NSWorkspace.shared.open(url)
        }
    }
}
