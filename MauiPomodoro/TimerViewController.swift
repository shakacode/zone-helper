//
//  ViewController.swift
//  MauiPomodoro
//
//  Created by Justin Gordon on 6/17/14.
//  Copyright (c) 2014 Justin Gordon. All rights reserved.
//

import UIKit

extension Int {
  var minutes: Int { return self * 60 }
  var minute: Int { return self * 60 }
}

class TimerViewController: UIViewController {
  
  let workTimeSeconds = 25.minutes
  var timer: NSTimer?
  var pomodoroState = PomodoroState()
  
  @IBOutlet var timerLabel : UILabel = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    refresh()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func refresh() {
    self.timerLabel.text = pomodoroState.timerValue()
  }
  
  func startTimer() {
    pomodoroState.start()
    timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "refresh", userInfo: nil, repeats: true)
    UIApplication.sharedApplication().idleTimerDisabled = true
  }
  
  func stopTimer() {
    if let theTimer = timer {
      theTimer.invalidate()
    }
    UIApplication.sharedApplication().idleTimerDisabled = false
    timer = nil
  }
  
  func pauseTimer() {
    stopTimer()
    pomodoroState.pause()
  }
  
  @IBAction func resetPressed(sender : UIButton) {
    pomodoroState.reset()
    stopTimer()
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

