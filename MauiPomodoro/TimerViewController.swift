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

class TimerViewController:  UIViewController, UIGestureRecognizerDelegate {
  var timer: NSTimer?
  var pomodoroState = PomodoroState()
  
  init(coder aDecoder: NSCoder!) {
    super.init(coder: aDecoder)
  }
  
  @IBOutlet var bottomButtonView: UIView
  @IBOutlet var timerLabel : UILabel
  @IBOutlet var workStateLabel: UILabel
  @IBOutlet var nextButton: UIButton
  @IBOutlet var optionsButton: UIButton
  
  //@IBOutlet var swipeGestureRecognizer: UISwipeGestureRecognizer
  
  override func viewDidLoad() {
    super.viewDidLoad()
    doWork()
    refresh()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func refresh() {
    var timerStatus = pomodoroState.timerStatus()
    timerLabel.text = timerStatus.text
    if timerStatus.secs < 0 || timer == nil {
      showBottomButtonBar()
    }
    
    workStateLabel.text = String(pomodoroState.consecutiveWorks)
    view.backgroundColor = pomodoroState.backgroundColor()
    if timerAtZero(timerStatus.secs) {
      AudioServicesPlaySystemSound(1304);
    }
  }
  
  @IBAction func swipeRightAction(sender: UISwipeGestureRecognizer) {
    startStop()
  }
  
  @IBAction func swipeLeftAction(sender: AnyObject) {
    startStop()
  }
  
  func timerAtZero(secs: Double) -> Bool {
    return -0.5 < secs && secs <= 0.5
  }
  
  func showBottomButtonBar() {
    var nextButtonTitle = pomodoroState.nextButtonLabel()
    nextButton.setTitle(nextButtonTitle, forState: UIControlState.Normal)
    bottomButtonView.hidden = false
    optionsButton.hidden = false
  }
  
  func hideBottomButtonBar() {
    bottomButtonView.hidden = true
    optionsButton.hidden = true
  }
  
  func startTimer() {
    pomodoroState.start()
    hideBottomButtonBar()
    timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "refresh", userInfo: nil, repeats: true)
    UIApplication.sharedApplication().idleTimerDisabled = true
  }
  
  func stopTimer() {
    if let theTimer = timer {
      theTimer.invalidate()
    }
    UIApplication.sharedApplication().idleTimerDisabled = false
    timer = nil
    showBottomButtonBar()
  }
  
  func pauseTimer() {
    stopTimer()
    pomodoroState.pause()
  }
  
  func reset() {
    stopTimer()
    refresh()
  }
  
  @IBAction func nextPressed(sender: UIButton) {
    pomodoroState.nextPressed()
    startTimer()
  }
  
  func doWork() {
    pomodoroState.resetWork()
    reset()
  }
  
  @IBAction func workPressed(sender : UIButton) {
    doWork()
  }
  
  @IBAction func shortBreakPressed(sender: UIButton) {
    pomodoroState.resetShortBreak()
    reset()
  }
  
  @IBAction func longBreakPressed(sender: UIButton) {
    pomodoroState.resetLongBreak()
    reset()
  }
  
  func startStop() {
    if timer {
      pauseTimer()
    } else {
      startTimer()
    }
  }
  
  @IBAction func startStopButton(sender : AnyObject) {
    // stop/start timer if timer stopped, or in work mode (b/c on desk)
    if !timer || timer && pomodoroState.mode == PomodoroMode.Work {
      startStop()
    }
  }
}

