//
//  ViewController.swift
//  MauiPomodoro
//
//  Created by Justin Gordon on 6/17/14.
//  Copyright (c) 2014 Justin Gordon. All rights reserved.
//

import UIKit
import AudioToolbox

extension Int {
  var minutes: Double { return Double(self) * 60.0 }
  var minute: Double { return Double(self) * 60.0 }
}

class TimerViewController: UIViewController {
  let overColor = UIColor.redColor()
  let workColor = UIColor.blackColor()
  let shortBreakColor = UIColor.brownColor()
  let longBreakColor = UIColor.darkGrayColor()
  var timer: NSTimer?
  var pomodoroState = PomodoroState()
  var activeColor: UIColor
  
  init(coder aDecoder: NSCoder!) {
    activeColor = workColor
    super.init(coder: aDecoder)
  }
  
  @IBOutlet var timerLabel : UILabel = nil

  override func viewDidLoad() {
    super.viewDidLoad()
    activeColor = workColor
    refresh()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func refresh() {
    var timerStatus = pomodoroState.timerStatus()
    self.timerLabel.text = timerStatus.text
    if timerStatus.secs < 0 {
      view.backgroundColor = overColor
    } else {
      view.backgroundColor = activeColor
    }
    if timerAtZero(timerStatus.secs) {
      AudioServicesPlaySystemSound(1304);
    }
  }
  
  func timerAtZero(secs: Double) -> Bool {
    return -0.5 < secs && secs <= 0.5
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
  
  func reset() {
    stopTimer()
    refresh()
  }
  
  @IBAction func resetPressed(sender : UIButton) {
    pomodoroState.resetWork()
    activeColor = workColor
    reset()
  }
  
  @IBAction func shortBreakPressed(sender: UIButton) {
    pomodoroState.resetShortBreak()
    activeColor = shortBreakColor
    reset()
  }
  
  @IBAction func longBreakPressed(sender: UIButton) {
    pomodoroState.resetLongBreak()
    activeColor = longBreakColor
    reset()
  }
  
  @IBAction func startStopButton(sender : AnyObject) {
    if timer {
      pauseTimer()
    } else {
      startTimer()
    }
  }
}

