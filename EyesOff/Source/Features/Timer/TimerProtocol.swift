import Foundation

protocol TimerManagerDelegate: AnyObject {
    func timerDidTriggerBreakReminder()
    func timerDidFinishBreakCountdown()
}

protocol TimerManagerProtocol {
    var delegate: TimerManagerDelegate? { get set }
    var isBreakAlertRunning: Bool { get }
    var remainingSeconds: Int { get }
    
    func startWorkTimer()
    func startBreakCountdown()
    func stopAllTimers()
}
