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
        timer.invalidate()
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
    
    private var workoutState = WorkoutState.inactive
    private var workoutInterval = 0.0
    private var startDate = Date()
    private var timer = Timer()
    private var countTimeType: CountTimeType = .reduced
    private var totalTime: Int = 60
    private var currentTime: Int = 0
    
    var updateTimeToUI: ((Int, String) -> Void)?
    var completedCountTime: (() -> Void)?
    
    func registerListeningNotification(totalTime: Int = 60, countTimeType: CountTimeType = .reduced) {
        self.totalTime = totalTime
        self.countTimeType = countTimeType
        NotificationCenter.default.addObserver(self, selector: #selector(observerMethod), name: UIApplication.didEnterBackgroundNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(observerMethod), name: UIApplication.didBecomeActiveNotification, object: nil)
        timer.invalidate()
    }
    
    func setTypeCountTime(countTimeType: CountTimeType = .reduced) {
        self.countTimeType = countTimeType
    }
    
    func cancelCountTime() {
        timer.invalidate()
    }
    
    private func updateTimer() {
        let interval = -Int(startDate.timeIntervalSinceNow)
        if interval <= totalTime{
            let timeRemaining = countTimeType == .increase ? interval : (totalTime - interval)
            currentTime = timeRemaining
            let hours = timeRemaining / 3600
            let minutes = timeRemaining / 60 % 60
            let seconds = timeRemaining % 60
            if let updateTimeToUI = self.updateTimeToUI {
                updateTimeToUI(interval, String(format:"%02i:%02i:%02i", hours, minutes, seconds))
            }
        } else {
            timer.invalidate()
            if let completedCountTime = self.completedCountTime {
                completedCountTime()
            }
        }
    }
    
    func showCurrentTime() -> (time: Int, timeString: String) {
        guard currentTime >= 0 else {
            return (0,"00:00:00")
        }
        let hours = currentTime / 3600
        let minutes = currentTime / 60 % 60
        let seconds = currentTime % 60
        return (currentTime, String(format:"%02i:%02i:%02i", hours, minutes, seconds))
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
