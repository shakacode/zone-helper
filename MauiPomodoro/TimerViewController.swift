//
//  ViewController.swift
//  MauiPomodoro
//
//  Created by Justin Gordon on 6/17/14.
//  Copyright (c) 2014 Justin Gordon. All rights reserved.
//

import UIKit
import QuartzCore

class TimerViewController:  UIViewController, UIGestureRecognizerDelegate, SettingsControllerDelegate {
  
  fileprivate let settingsWidth:CGFloat = 300
  fileprivate let settingsAnimationDuration:CGFloat = 0.5
  
  var lastMode = PomodoroMode.work
  
  var refreshTimer: Timer?
  
  var overtimeColorSet = false
  
  var currentBackgroundLayer: CALayer?
    
  var settingsController: UINavigationController!
  
  required init?(coder aDecoder: NSCoder) {
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
    showLaunchScreen()
    doWork()
    refresh()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  var refreshOnRotate = false
  
  override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
    refreshOnRotate = true
    refresh()
    refreshOnRotate = false
  }
  
  func refresh() {
    let timerStatus = pomodoroState.timerStatus()
    timerLabel!.text = timerStatus.text
    
    if (timerStatus.secs < 0 && pomodoroState.mode != PomodoroMode.meeting) || pomodoroState.paused() {
      showBottomButtonBar()
    }
    
    let cw = pomodoroState.consecutiveWorks
    workStateLabel!.text = cw > 0 ? String(cw) : ""
    
    statusLabel!.text = pomodoroState.statusLabel()

    let setOvertimeColor = (pomodoroState.mode != PomodoroMode.meeting) && timerStatus.secs < 0 && (!overtimeColorSet || refreshOnRotate)

    let switchColor = (lastMode != pomodoroState.mode) || setOvertimeColor || refreshOnRotate || (overtimeColorSet && timerStatus.secs >= 0)

    if switchColor {
      lastMode = pomodoroState.mode
      switchBackgroundColor(setOvertimeColor)
    }
    
    if setOvertimeColor {
      overtimeColorSet = true
    }
    
    pomodoroState.checkPlayedAlarm()
  }
  
  func switchBackgroundColor(_ setOvertimeColor: Bool) {
    if lastMode == PomodoroMode.work && !setOvertimeColor {
      if let cur = currentBackgroundLayer {
        cur.removeFromSuperlayer()
        currentBackgroundLayer = nil
      }
      view.backgroundColor = UIColor.black
    } else {
      view.backgroundColor = UIColor.clear
      let backgroundLayer = pomodoroState.backgroundGradient()
      backgroundLayer.frame = view.bounds;
      
      if let cur = currentBackgroundLayer {
        view.layer.replaceSublayer(cur, with: backgroundLayer)
      } else {
        view.layer.insertSublayer(backgroundLayer, at: 0)
      }
      currentBackgroundLayer = backgroundLayer
    }
  }
  
  @IBAction func swipeRightAction(_ sender: UISwipeGestureRecognizer) {
    startStop()
  }
  
  @IBAction func swipeLeftAction(_ sender: AnyObject) {
    startStop()
  }
  
  func timerAtZero(_ secs: Double) -> Bool {
    return -0.25 < secs && secs <= 0.25
  }
  
  func showBottomButtonBar() {
    let nextButtonTitle = pomodoroState.nextButtonLabel()
    nextButton!.setTitle(nextButtonTitle, for: UIControlState())
    bottomButtonView!.isHidden = false
    optionsButton!.isHidden = false
  }
  
  func hideBottomButtonBar() {
    bottomButtonView!.isHidden = true
    optionsButton!.isHidden = true
  }
  
  func startTimer() {
    pomodoroState.start()
    hideBottomButtonBar()
    if refreshTimer == nil  {
      refreshTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(TimerViewController.refresh), userInfo: nil, repeats: true)
    }
    UIApplication.shared.isIdleTimerDisabled = true
  }
  
  func stopTimer() {
    if pomodoroState.mode == PomodoroMode.meeting {
      if let theTimer = refreshTimer  {
        theTimer.invalidate()
        refreshTimer = nil
      }
    }
    UIApplication.shared.isIdleTimerDisabled = false
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
  
  func updateSettings() {
    pomodoroState.resetWork()
  }
  
  @IBAction func nextPressed(_ sender: UIButton) {
    pomodoroState.nextPressed()
    overtimeColorSet = false
    startTimer()
  }
  
  func doWork() {
    pomodoroState.resetWork()
    reset()
  }
  
  @IBAction func workPressed(_ sender : UIButton) {
    doWork()
  }
  
  @IBAction func shortBreakPressed(_ sender: UIButton) {
    pomodoroState.resetShortBreak()
    reset()
  }
  
  @IBAction func longBreakPressed(_ sender: UIButton) {
    pomodoroState.resetLongBreak()
    reset()
  }
  
  @IBAction func meetingPressed(_ sender: UIButton) {
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
  
  @IBAction func startStopButton(_ sender : AnyObject) {
    // stop/start timer if timer stopped, or in work mode (b/c on desk)
    if !pomodoroState.startedSinceReset() ||  pomodoroState.paused() || (pomodoroState.mode == PomodoroMode.work) || (pomodoroState.mode == PomodoroMode.meeting) || (pomodoroState.mode == PomodoroMode.shortBreak) ||
      (pomodoroState.mode == PomodoroMode.longBreak) {
      startStop()
    }
  }
  
  @IBAction func optionsButtonTapped(_ sender: AnyObject) {
    

    
    settingsController = storyboard!.instantiateViewController(withIdentifier: "Settings") as! UINavigationController
    addChildViewController(settingsController)
    
    let backdrop = BackdropView(frame: view.frame, dismissController: settingsController, dismissDuration: settingsAnimationDuration)
    view.addSubview(backdrop)
    self.view.addSubview(settingsController.view)
    
    let controller = settingsController.topViewController! as! SettingsController
    settingsController.view.frame = CGRect(x: -settingsWidth, y: 0, width: settingsWidth, height: view.frame.height)
    controller.view.frame = CGRect(x: 0, y: 0, width: settingsWidth, height: view.frame.height)
    controller.delegate = self
    
    UIView.animate(withDuration: 0.5, animations: { [unowned self] in
      self.settingsController.view.frame.origin.x = 0
    }) 
  }

    fileprivate func showLaunchScreen() {
        let storyboard = UIStoryboard(name: "Launch Screen", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()!
        controller.view.frame = view.frame
        addChildViewController(controller)
        view.addSubview(controller.view)
        UIView.animate(withDuration: 0.5, animations: {
          controller.view.layer.opacity = 0
        }, completion: { result in
          controller.view.removeFromSuperview()
          controller.removeFromParentViewController()
        }) 
    }
  
}

