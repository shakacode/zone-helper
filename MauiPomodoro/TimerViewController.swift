//
//  ViewController.swift
//  MauiPomodoro
//
//  Created by Justin Gordon on 6/17/14.
//  Copyright (c) 2014 Justin Gordon. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    
    let workTimeSeconds = 25 * 60
    
    var startTime: NSDate?
    
    //var timer = NSTimer()
    var timer: NSTimer?
    var pomodoroState = PomodoroState()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func refresh() {
        self.timerLabel.text = pomodoroState.timerValue()
    }
    
    @IBOutlet var timerLabel : UILabel = nil

    func startTimer() {
        pomodoroState.start()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "refresh", userInfo: nil, repeats: true)
    }
 
    func pauseTimer() {
        if let theTimer = timer {
            theTimer.invalidate()
        }
        timer = nil
        pomodoroState.pause()
    }
    
    @IBAction func resetPressed(sender : UIButton) {
        self.startTime = NSDate()
        pomodoroState.reset()
        refresh()
    }

    @IBAction func startStopButton(sender : AnyObject) {
        if timer {
            pauseTimer()
        } else {
            startTimer()
        }
    }
}

