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

    @IBOutlet weak var workDatePicker: UIDatePicker!
    @IBOutlet weak var workTimeField: UITextField!
    @IBOutlet weak var shortBreakTimeField: UITextField!
    @IBOutlet weak var shortBreakDatePicker: UIDatePicker!
    @IBOutlet weak var longBreakTimeField: UITextField!
    @IBOutlet weak var longBreakDatePicker: UIDatePicker!
   
    
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
    var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    prefs.setObject(PomodoroState.convertMinSecsToSecs(workTimeField.text), forKey: "WORKTIME")
    prefs.setObject(PomodoroState.convertMinSecsToSecs(shortBreakTimeField.text), forKey: "SHORTBREAKTIME")
    prefs.setObject(PomodoroState.convertMinSecsToSecs(longBreakTimeField.text), forKey: "LONGBREAKTIME")
    prefs.synchronize()
    pomodoroState.resetWork()
    setTimeLabels()
  }
  
    @IBAction func workTimeButtonPressed(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.dateFromString(self.workTimeField.text)
        workDatePicker.date = date!
        shortBreakDatePicker.hidden = true
        longBreakDatePicker.hidden = true
        workDatePicker.hidden = false
    }
    @IBAction func shortBreakButtonPressed(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.dateFromString(self.shortBreakTimeField.text)
        shortBreakDatePicker.date = date!
        workDatePicker.hidden = true
        longBreakDatePicker.hidden = true
        shortBreakDatePicker.hidden = false
    }
    @IBAction func longBreakButtonPressed(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.dateFromString(self.longBreakTimeField.text)
        longBreakDatePicker.date = date!
        workDatePicker.hidden = true
        shortBreakDatePicker.hidden = true
        longBreakDatePicker.hidden = false
    }
    
    @IBAction func workDatePickerAction(sender: AnyObject) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        var strDate = dateFormatter.stringFromDate(workDatePicker.date)
        self.workTimeField.text = strDate
        workDatePicker.hidden = true
    }
    
    @IBAction func shortBreakDatePickerAction(sender: AnyObject) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        var strDate = dateFormatter.stringFromDate(shortBreakDatePicker.date)
        self.shortBreakTimeField.text = strDate
        shortBreakDatePicker.hidden = true
    }

    @IBAction func longBreakDatePickerAction(sender: AnyObject) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        var strDate = dateFormatter.stringFromDate(longBreakDatePicker.date)
        self.longBreakTimeField.text = strDate
        longBreakDatePicker.hidden = true
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

