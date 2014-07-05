//
//  OptionsViewController.swift
//  MauiPomodoro
//
//  Created by Justin Gordon on 6/17/14.
//  Copyright (c) 2014 Justin Gordon. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {
  
  @IBOutlet var demoModeSwitch: UISwitch
  @IBOutlet var workTimeLabel: UILabel
  @IBOutlet var shortBreakTimeLabel: UILabel
  @IBOutlet var longBreakTimeLabel: UILabel
  
  override func viewDidLoad() {
    super.viewDidLoad()
    demoModeSwitch.on = demoMode
    setTimeLabels()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func donePressed(sender : UIButton) {
    self.dismissModalViewControllerAnimated(true)
    //self.parentViewController.refresh()
  }
  
  
  @IBAction func demoModeToggled(sender: AnyObject)
  {
    println("Demo toggled to \(demoModeSwitch.on)")
    demoMode = demoModeSwitch.on
    pomodoroState.resetWork()
    setTimeLabels()
  }
  
  func setTimeLabels() {
    workTimeLabel.text = PomodoroMode.Work.totalTimeMinSecs()
    shortBreakTimeLabel.text = PomodoroMode.ShortBreak.totalTimeMinSecs()
    longBreakTimeLabel.text = PomodoroMode.LongBreak.totalTimeMinSecs()
  }
}

