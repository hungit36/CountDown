//
//  CountTimeService.swift
//  CountTime
//
//  Created by Hưng Nguyễn on 8/20/21.
//  Email: hungnguyen.it36@gmail.com
//

import UIKit

class CountTimeService: NSObject {
    
    static let shared = CountTimeService()
    
    override init() {
        super.init()
        self.registerListeningNotification()
    }
    
    deinit {
        cancelCountTime()
    }
    
    enum WorkoutState {
        case inactive
        case active
        case paused
    }
    
    enum CountTimeType {
        case increase
        case reduced
    }
    
    enum TimeShowToUIType {
        case full
        case minute_second
        case number
    }
    
    private var workoutState = WorkoutState.inactive
    private var workoutInterval = 0.0
    private var startDate = Date()
    private var timer = Timer()
    private var countTimeType: CountTimeType = .reduced
    private var totalTime: Int = 60
    private var currentTime: Int = 0
    private var timeShowToUIType : TimeShowToUIType = .full
    
    var updateTimeToUI: ((Int, String) -> Void)?
    var completedCountTime: (() -> Void)?
    
    func registerListeningNotification(totalTime: Int = 60, countTimeType: CountTimeType = .reduced, timeShowToUIType : TimeShowToUIType = .full) {
        self.timeShowToUIType = timeShowToUIType
        self.totalTime = totalTime
        self.countTimeType = countTimeType
        startDate = Date()
        timer = Timer()
        workoutInterval = 0.0
        currentTime = 0
        timer.invalidate()
        NotificationCenter.default.addObserver(self, selector: #selector(observerMethod), name: UIApplication.didEnterBackgroundNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(observerMethod), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    func setTypeCountTime(countTimeType: CountTimeType = .reduced) {
        self.countTimeType = countTimeType
    }
    
    func cancelCountTime() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        timer.invalidate()
    }
    
    private func convertTimeintervalToTImeString() -> String {
        guard currentTime >= 0 else {
            switch timeShowToUIType {
            case .number:
                return ("00")
            case .minute_second:
                return ("00:00")
            default:
                return ("00:00:00")
            }
        }
        let hours = currentTime / 3600
        let minutes = currentTime / 60 % 60
        let seconds = currentTime % 60
        switch timeShowToUIType {
        case .number:
            return String(format:"%02i", currentTime)
        case .minute_second:
            return String(format:"%02i:%02i", minutes, seconds)
        default:
            return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
        }
    }
    
    private func updateTimer() {
        let interval = -Int(startDate.timeIntervalSinceNow)
        if interval <= totalTime{
            let timeRemaining = countTimeType == .increase ? interval : (totalTime - interval)
            currentTime = timeRemaining
            if let updateTimeToUI = self.updateTimeToUI {
                updateTimeToUI(currentTime, convertTimeintervalToTImeString())
            }
        } else {
            cancelCountTime()
            if let completedCountTime = self.completedCountTime {
                completedCountTime()
            }
        }
    }
    
    func showCurrentTime() -> (time: Int, timeString: String) {
        return (currentTime, convertTimeintervalToTImeString())
    }
    
    func startCountTime() {
        if workoutState == .inactive {
            startDate = Date()
        } else if workoutState == .paused {
            startDate = Date().addingTimeInterval(-workoutInterval)
        }
        workoutState = .active
        updateTimer()
        _foregroundTimer(repeated: true)
    }

    func pausedCountTime(){
        // record workout duration
        workoutInterval = floor(-startDate.timeIntervalSinceNow)
        workoutState = .paused
        timer.invalidate()
    }

    private func _foregroundTimer(repeated: Bool) -> Void {
        //Define a Timer
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction(_:)), userInfo: nil, repeats: true)
    }

    @objc private func timerAction(_ timer: Timer) {
        self.updateTimer()
    }

    @objc private func observerMethod(notification: NSNotification) {

        if notification.name == UIApplication.didEnterBackgroundNotification {
            // stop UI update
            timer.invalidate()
        } else if notification.name == UIApplication.didBecomeActiveNotification {
            if workoutState == .active {
                updateTimer()
                _foregroundTimer(repeated: true)
            }
        }
    }
}
