//
//  OptionsViewController.swift
//  MauiPomodoro
//
//  Created by Justin Gordon on 6/17/14.
//  Copyright (c) 2014 Justin Gordon. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {
  
  @IBOutlet var demoModeSwitch: UISwitch?

    @IBOutlet weak var workTimeField: UITextField!
    @IBOutlet weak var shortBreakTimeField: UITextField!
    @IBOutlet weak var longBreakTimeField: UITextField!
   
    
  override func viewDidLoad() {
    super.viewDidLoad()
    demoModeSwitch!.on = demoMode
    setTimeLabels()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func donePressed(sender : UIButton) {
    self.dismissViewControllerAnimated(true, nil)
    //self.parentViewController.refresh()
    var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    prefs.setObject(PomodoroState.convertMinSecsToSecs(workTimeField.text), forKey: "WORKTIME")
    prefs.setObject(PomodoroState.convertMinSecsToSecs(shortBreakTimeField.text), forKey: "SHORTBREAKTIME")
    prefs.setObject(PomodoroState.convertMinSecsToSecs(longBreakTimeField.text), forKey: "LONGBREAKTIME")
    prefs.synchronize()
  }
  
  
  @IBAction func demoModeToggled(sender: AnyObject)
  {
    println("Demo toggled to \(demoModeSwitch!.on)")
    demoMode = demoModeSwitch!.on
    pomodoroState.resetWork()
    setTimeLabels()
  }
  
  func setTimeLabels() {
    var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    workTimeField!.text = PomodoroState.convertSecsToMinSecs(prefs.doubleForKey("WORKTIME"))
    shortBreakTimeField!.text = PomodoroState.convertSecsToMinSecs(prefs.doubleForKey("SHORTBREAKTIME"))
    longBreakTimeField!.text = PomodoroState.convertSecsToMinSecs(prefs.doubleForKey("LONGBREAKTIME"))

    
      }
}

