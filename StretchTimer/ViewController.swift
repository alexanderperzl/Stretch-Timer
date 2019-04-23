//
//  ViewController.swift
//  StretchTimer
//
//  Created by Alexander Perzl on 04.04.19.
//  Copyright © 2019 Alexander Perzl. All rights reserved.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController{
    
    var maxTime: TimeInterval
    var maxTimeMinutes: Int
    var maxTimeSeconds: Int
    var remainingTime: TimeInterval
    var maxRounds: Int
    var currentRound: Int
    var timer = Timer()
    
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var startOutlet: UIButton!
    @IBOutlet weak var stopOutlet: UIButton!
    @IBOutlet weak var roundsLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        maxTime = 70
        maxTimeMinutes = 0
        maxTimeSeconds = 30
        remainingTime = maxTime
        maxRounds = 6
        currentRound = 1
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        remainingTime = maxTime
        updateRemainingTimeLabel()
        updateRoundsLabel()
    }
    
    @IBAction func startStop(_ sender: UIButton) {
        if sender.currentTitle == "START" {
            sender.setTitle("STOP", for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.counter), userInfo: nil, repeats: true)
            UIApplication.shared.isIdleTimerDisabled = true
            
        } else {
            sender.setTitle("START", for: .normal)
            stopTimer()
        }
        
    }
    
    @objc func counter() {
        remainingTime -= 1
        
        if remainingTime < 0 {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            if currentRound == maxRounds {
                stopTimer()
            } else {
                currentRound += 1
                updateRoundsLabel()
                remainingTime = maxTime
                updateRemainingTimeLabel()
            }
        } else {
            updateRemainingTimeLabel()
        }
    }
    
    
    @IBAction func reset(_ sender: UIButton) {
        stopTimer()
        remainingTime = maxTime
        currentRound = 1
        startOutlet.setTitle("START", for: .normal)
        updateRoundsLabel()
        updateRemainingTimeLabel()
    }
    
    
    func updateRemainingTimeLabel() {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        remainingTimeLabel.text = formatter.string(from: remainingTime)
    }
    
    func updateRoundsLabel() {
        roundsLabel.text = "Round \(currentRound) / \(maxRounds)"
    }
    
    func stopTimer() {
        timer.invalidate()
        UIApplication.shared.isIdleTimerDisabled = false
    }
}

