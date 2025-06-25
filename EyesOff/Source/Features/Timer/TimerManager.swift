import Foundation

class TimerManager: TimerManagerProtocol {
    weak var delegate: TimerManagerDelegate?
    
    private var workTimer: Timer?
    private var countdownTimer: Timer?
    private let workInterval: TimeInterval
    
    private(set) var isBreakAlertRunning = false
    private(set) var remainingSeconds = AppConstants.breakAlertDurationSeconds
    
    init(workIntervalMinutes: Double = AppConstants.workIntervalMinutes) {
        self.workInterval = workIntervalMinutes * 60
    }
    
    func startWorkTimer() {
        stopAllTimers()
        workTimer = Timer.scheduledTimer(withTimeInterval: workInterval, repeats: true) { [weak self] _ in
            self?.delegate?.timerDidTriggerBreakReminder()
        }
    }
    
    func startBreakCountdown() {
        isBreakAlertRunning = true
        remainingSeconds = AppConstants.breakAlertDurationSeconds
        
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.remainingSeconds -= 1
            
            if self.remainingSeconds <= 0 {
                timer.invalidate()
                self.isBreakAlertRunning = false
                self.delegate?.timerDidFinishBreakCountdown()
            }
        }
    }
    
    func stopAllTimers() {
        workTimer?.invalidate()
        countdownTimer?.invalidate()
        isBreakAlertRunning = false
    }
}
