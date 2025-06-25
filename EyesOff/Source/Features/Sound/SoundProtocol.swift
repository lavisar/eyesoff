import Foundation

protocol SoundManagerProtocol {
    func getSystemSoundNames() -> [String]
    func getSelectedSound() -> String
    func saveSelectedSound(_ name: String)
    func playSelectedSound()
    func playSound(named: String)
}
