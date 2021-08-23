//
//  FirstViewController.swift
//  CountTime
//
//  Created by Hưng Nguyễn on 8/21/21.
//  Email: hungnguyen.it36@gmail.com
//

import UIKit

class FirstViewController: UIViewController {
    
    @IBOutlet weak var increase: UIButton!
    
    @IBOutlet weak var reduced: UIButton!

    @IBOutlet weak var start: UIButton!

    @IBOutlet weak var paused: UIButton!

    @IBOutlet weak var timerLabel: UILabel!
    
    private lazy var secondViewController: SecondViewController = {
        let secondViewController = SecondViewController.instantiate(storyboard: "Main", identifier: "SecondViewController")
        return secondViewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerLabel.text = "00:00:00"
        self.title = "CountTime Demo"
        paused.isHidden = true
        CountTimeService.shared.registerListeningNotification(totalTime: 600)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        timerLabel.text = CountTimeService.shared.showCurrentTime().timeString
        CountTimeService.shared.updateTimeToUI = { [weak self] (interval, timeString) in
            guard let self = self else { return }
            self.timerLabel.text = timeString
        }
        CountTimeService.shared.completedCountTime = { [weak self] in
            self?.showAlert(title: "", message: "Completed CountTime!")
        }
    }
    
    @IBAction func chooseTypeCountTime (_ sender: UIButton) {
        CountTimeService.shared.setTypeCountTime(countTimeType: sender == increase ? .increase : .reduced)
        increase.setTitle("▲ increase" + (sender == increase ? " ⦿" : ""), for: .normal)
        reduced.setTitle("▼ reduced" + (sender == reduced ? " ⦿" : ""), for: .normal)
    }
    
    @IBAction func startButton(_ sender: UIButton) {
        start.isHidden = true
        paused.isHidden = false
        CountTimeService.shared.startCountTime()
    }

    @IBAction func pausedButton(_ sender: UIButton) {
        CountTimeService.shared.pausedCountTime()
        pauseWorkout()
    }
    
    @IBAction func nextScreen(_ sender: UIButton) {
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }

    func pauseWorkout(){
        paused.isHidden = true
        start.isHidden = false
    }
}
