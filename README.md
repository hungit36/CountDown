# CountTime
Count increase or reduced time even when the app is running in the background.
Please do not copy in any form.
Get website design, mobile application (IOS, Android, Smart TV) please contact via e-mail: hungnguyen.it36@gmail.com


Use:

1. register
CountTimeService.shared.registerListeningNotification(totalTime: 600)

2. listening event and update to UI
timerLabel.text = CountTimeService.shared.showCurrentTime().timeString
CountTimeService.shared.updateTimeToUI = { [weak self] (interval, timeString) in
    guard let self = self else { return }
    self.timerLabel.text = timeString
    print("interval: \(interval)")
}
CountTimeService.shared.completedCountTime = { [weak self] in
    self?.showAlert(title: "", message: "Completed CountTime!")
}
  
3. start count
CountTimeService.shared.startCountTime()

4.pause
CountTimeService.shared.pausedCountTime()
