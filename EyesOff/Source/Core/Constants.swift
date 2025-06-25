import Foundation

struct AppConstants {
    static let workIntervalMinutes: Double = 20
    static let breakAlertDurationSeconds = 20
    static let defaultSoundName = "Submarine"
    static let analyticsURL = "https://eyesoff.vercel.app/api/install"
    static let bugReportEmail = "lavisar.dev@gmail.com"
    
    // UserDefaults Keys
    struct UserDefaultsKeys {
        static let selectedSound = "SelectedSound"
        static let appLanguage = "AppLanguage"
        static let analysisLaunched = "EyesOff-Analysis"
    }
}
