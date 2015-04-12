//
//  ViewController.swift
//  MauiPomodoro
//
//  Created by Justin Gordon on 6/17/14.
//  Copyright (c) 2014 Justin Gordon. All rights reserved.
//

import UIKit
import QuartzCore

class TimerViewController:  UIViewController, UIGestureRecognizerDelegate {
  var lastMode = PomodoroMode.Work
  
  var refreshTimer: NSTimer?
  
  var overtimeColorSet = false
  
  var currentBackgroundLayer: CALayer?
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  @IBOutlet var bottomButtonView: UIView?
  @IBOutlet var timerLabel : UILabel?
  @IBOutlet var workStateLabel: UILabel?
  @IBOutlet var nextButton: UIButton?
  @IBOutlet var optionsButton: UIButton?
  @IBOutlet var statusLabel: UILabel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    doWork()
    refresh()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  var refreshOnRotate = false
  
  override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
    refreshOnRotate = true
    refresh()
    refreshOnRotate = false
  }
  
  func refresh() {
    var timerStatus = pomodoroState.timerStatus()
    timerLabel!.text = timerStatus.text
    
    if (timerStatus.secs < 0 && pomodoroState.mode != PomodoroMode.Meeting) || pomodoroState.paused() {
      showBottomButtonBar()
    }
    
    var cw = pomodoroState.consecutiveWorks
    workStateLabel!.text = cw > 0 ? String(cw) : ""
    
    statusLabel!.text = pomodoroState.statusLabel()

    var setOvertimeColor = (pomodoroState.mode != PomodoroMode.Meeting) && timerStatus.secs < 0 && (!overtimeColorSet || refreshOnRotate)

    var switchColor = (lastMode != pomodoroState.mode) || setOvertimeColor || refreshOnRotate || (overtimeColorSet && timerStatus.secs >= 0)

    if switchColor {
      lastMode = pomodoroState.mode
      switchBackgroundColor(setOvertimeColor)
    }
    
    if setOvertimeColor {
      overtimeColorSet = true
    }
    
    pomodoroState.checkPlayedAlarm()
  }
  
  func switchBackgroundColor(setOvertimeColor: Bool) {
    if lastMode == PomodoroMode.Work && !setOvertimeColor {
      if let cur = currentBackgroundLayer {
        cur.removeFromSuperlayer()
        currentBackgroundLayer = nil
      }
      view.backgroundColor = UIColor.blackColor()
    } else {
      view.backgroundColor = UIColor.clearColor()
      var backgroundLayer = pomodoroState.backgroundGradient()
      backgroundLayer.frame = view.bounds;
      
      if let cur = currentBackgroundLayer {
        view.layer.replaceSublayer(cur, with: backgroundLayer)
      } else {
        view.layer.insertSublayer(backgroundLayer, atIndex: 0)
      }
      currentBackgroundLayer = backgroundLayer
    }
  }
  
  @IBAction func swipeRightAction(sender: UISwipeGestureRecognizer) {
    startStop()
  }
  
  @IBAction func swipeLeftAction(sender: AnyObject) {
    startStop()
  }
  
  func timerAtZero(secs: Double) -> Bool {
    return -0.25 < secs && secs <= 0.25
  }
  
  func showBottomButtonBar() {
    var nextButtonTitle = pomodoroState.nextButtonLabel()
    nextButton!.setTitle(nextButtonTitle, forState: UIControlState.Normal)
    bottomButtonView!.hidden = false
    optionsButton!.hidden = false
  }
  
  func hideBottomButtonBar() {
    bottomButtonView!.hidden = true
    optionsButton!.hidden = true
  }
  
  func startTimer() {
    pomodoroState.start()
    hideBottomButtonBar()
    if refreshTimer == nil  {
      refreshTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "refresh", userInfo: nil, repeats: true)
    }
    UIApplication.sharedApplication().idleTimerDisabled = true
  }
  
  func stopTimer() {
    if pomodoroState.mode == PomodoroMode.Meeting {
      if let theTimer = refreshTimer  {
        theTimer.invalidate()
        refreshTimer = nil
      }
    }
    UIApplication.sharedApplication().idleTimerDisabled = false
    showBottomButtonBar()
  }
  
  func pauseTimer() {
    stopTimer()
    pomodoroState.pause()
  }
  
  func reset() {
    stopTimer()
    refresh()
    overtimeColorSet = false
  }
  
  @IBAction func nextPressed(sender: UIButton) {
    pomodoroState.nextPressed()
    overtimeColorSet = false
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
  
  @IBAction func meetingPressed(sender: UIButton) {
    pomodoroState.resetMeeting()
    reset()
  }
  
  func startStop() {
    if pomodoroState.paused() || !pomodoroState.startedSinceReset() {
      startTimer()
    } else {
      pauseTimer()
    }
  }
  
  @IBAction func startStopButton(sender : AnyObject) {
    // stop/start timer if timer stopped, or in work mode (b/c on desk)
    if !pomodoroState.startedSinceReset() ||  pomodoroState.paused() || (pomodoroState.mode == PomodoroMode.Work || pomodoroState.mode == PomodoroMode.Meeting) {
      startStop()
    }
  }
}

