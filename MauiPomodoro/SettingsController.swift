//
//  SettingsController.swift
//  ZoneHelper
//
//  Created by Алексей Карасев on 01/05/16.
//  Copyright © 2016 Justin Gordon. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController {

    @IBOutlet var timeInputs: [UITextField]!
    @IBOutlet weak var demoSwitch: UISwitch!
    private var dateFormatter: NSDateFormatter!
    private var firstResponder: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let times = Settings.instance.times
        for (index, input) in timeInputs.enumerate() {
//          disable input cursor
            input.valueForKey("textInputTraits")?.setValue(UIColor.clearColor(), forKey: "insertionPointColor")
            
            input.text = times[index]
        }
        demoSwitch.on = Settings.instance.demo
    }
    
    
    @IBAction func editingDidBegin(sender: UITextField) {
        
        let picker = UIDatePicker()
        picker.datePickerMode = .CountDownTimer
        if let text = sender.text {
            let date = dateFormatter.dateFromString(text)!
            picker.setDate(date, animated: true)
        }
        picker.addTarget(self, action: #selector(SettingsController.pickerChanged(_:)), forControlEvents: [.ValueChanged])

        sender.inputView = picker
        firstResponder = sender
    }
    
    @IBAction func editingDidEnd(sender: UITextField) {
        sender.inputView = nil
        let times = timeInputs.map { $0.text! }
        Settings.instance.times = times
    }
    
    @IBAction func demoTapped(sender: UISwitch) {
        Settings.instance.demo = sender.on
    }
    @IBAction func tableTapped(sender: AnyObject) {
        tableView.endEditing(true)
    }
    
    @IBAction func pickerChanged(sender: AnyObject) {
        let picker = sender as! UIDatePicker
        firstResponder.text = dateFormatter.stringFromDate(picker.date)
    }
    
}
