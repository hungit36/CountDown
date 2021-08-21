//
//  SecondViewController.swift
//  CountTime
//
//  Created by Hưng Nguyễn on 8/21/21.
//  Email: hungnguyen.it36@gmail.com
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Second ViewController"
        let backButton = UIButton()
        backButton.setTitle("◀︎", for: .normal)
        backButton.setTitleColor(.black, for: .normal)
        backButton.addTarget(self, action: #selector(_back), for: .touchUpInside)
        self.navigationItem.leftButton(button: backButton)
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

    @objc func _back() {
        self.navigationController?.popViewController(animated: true)
    }
}
