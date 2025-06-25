import Cocoa
import Foundation

class SoundManager: SoundManagerProtocol {
    private let userDefaults: UserDefaultsHelper
    
    init(userDefaults: UserDefaultsHelper = UserDefaultsHelper.shared) {
        self.userDefaults = userDefaults
    }
    
    func getSystemSoundNames() -> [String] {
        let soundFolder = "/System/Library/Sounds"
        let fileManager = FileManager.default
        guard let items = try? fileManager.contentsOfDirectory(atPath: soundFolder) else { return [] }
        
        return items
            .filter { $0.hasSuffix(".aiff") }
            .map { $0.replacingOccurrences(of: ".aiff", with: "") }
    }
    
    func getSelectedSound() -> String {
        return userDefaults.string(forKey: AppConstants.UserDefaultsKeys.selectedSound) ?? AppConstants.defaultSoundName
    }
    
    func saveSelectedSound(_ name: String) {
        userDefaults.set(name, forKey: AppConstants.UserDefaultsKeys.selectedSound)
    }
    
    func playSelectedSound() {
        let soundName = getSelectedSound()
        playSound(named: soundName)
    }
    
    func playSound(named name: String) {
        NSSound(named: NSSound.Name(name))?.play()
    }
}
