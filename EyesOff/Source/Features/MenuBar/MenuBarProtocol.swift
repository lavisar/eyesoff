import Cocoa

protocol MenuBarManagerDelegate: AnyObject {
    func menuBarDidSelectSound(_ sound: String)
    func menuBarDidSelectLanguage(_ language: String)
    func menuBarDidToggleLoginItem(_ enabled: Bool)
    func menuBarDidRequestNotificationSettings()
    func menuBarDidRequestAbout()
    func menuBarDidRequestBugReport()
    func menuBarDidRequestQuit()
}

protocol MenuBarManagerProtocol {
    var delegate: MenuBarManagerDelegate? { get set }
    func setupMenuBar()
    func updateMenuBar()
}
