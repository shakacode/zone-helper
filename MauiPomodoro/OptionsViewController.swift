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
    demoModeSwitch!.isOn = demoMode
    setTimeLabels()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func donePressed(_ sender : UIButton) {
    self.dismiss(animated: true, completion: nil)
    let prefs:UserDefaults = UserDefaults.standard
    prefs.set(PomodoroState.convertMinSecsToSecs(workTimeField.text!), forKey: "WORKTIME")
    prefs.set(PomodoroState.convertMinSecsToSecs(shortBreakTimeField.text!), forKey: "SHORTBREAKTIME")
    prefs.set(PomodoroState.convertMinSecsToSecs(longBreakTimeField.text!), forKey: "LONGBREAKTIME")
    prefs.synchronize()
    pomodoroState.resetWork()
    setTimeLabels()
  }
  
    @IBAction func workTimeButtonPressed(_ sender: AnyObject) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: self.workTimeField.text!)
        workDatePicker.date = date!
        shortBreakDatePicker.isHidden = true
        longBreakDatePicker.isHidden = true
        workDatePicker.isHidden = false
    }
    @IBAction func shortBreakButtonPressed(_ sender: AnyObject) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: self.shortBreakTimeField.text!)
        shortBreakDatePicker.date = date!
        workDatePicker.isHidden = true
        longBreakDatePicker.isHidden = true
        shortBreakDatePicker.isHidden = false
    }
    @IBAction func longBreakButtonPressed(_ sender: AnyObject) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: self.longBreakTimeField.text!)
        longBreakDatePicker.date = date!
        workDatePicker.isHidden = true
        shortBreakDatePicker.isHidden = true
        longBreakDatePicker.isHidden = false
    }
    
    @IBAction func workDatePickerAction(_ sender: AnyObject) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let strDate = dateFormatter.string(from: workDatePicker.date)
        self.workTimeField.text = strDate
        workDatePicker.isHidden = true
    }
    
    @IBAction func shortBreakDatePickerAction(_ sender: AnyObject) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let strDate = dateFormatter.string(from: shortBreakDatePicker.date)
        self.shortBreakTimeField.text = strDate
        shortBreakDatePicker.isHidden = true
    }

    @IBAction func longBreakDatePickerAction(_ sender: AnyObject) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let strDate = dateFormatter.string(from: longBreakDatePicker.date)
        self.longBreakTimeField.text = strDate
        longBreakDatePicker.isHidden = true
    }
    
    @IBAction func demoModeToggled(_ sender: AnyObject)
  {
    print("Demo toggled to \(demoModeSwitch!.isOn)")
    demoMode = demoModeSwitch!.isOn
    pomodoroState.resetWork()
    setTimeLabels()
  }
  
  func setTimeLabels() {
    let prefs:UserDefaults = UserDefaults.standard
    workTimeField!.text = PomodoroState.convertSecsToMinSecs(prefs.double(forKey: "WORKTIME"))
    shortBreakTimeField!.text = PomodoroState.convertSecsToMinSecs(prefs.double(forKey: "SHORTBREAKTIME"))
    longBreakTimeField!.text = PomodoroState.convertSecsToMinSecs(prefs.double(forKey: "LONGBREAKTIME"))

    
      }
}

