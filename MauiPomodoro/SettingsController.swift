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
    private var dateFormatter: NSDateFormatter!
    private var firstResponder: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
    }
    
    
    @IBAction func editingDidBegin(sender: AnyObject) {
        let textField = sender as! UITextField
        
        let picker = UIDatePicker()
        picker.datePickerMode = .CountDownTimer
        if let text = textField.text {
            let date = dateFormatter.dateFromString(text)!
            picker.setDate(date, animated: true)
        }
        picker.addTarget(self, action: #selector(SettingsController.pickerChanged(_:)), forControlEvents: [.ValueChanged])

        textField.inputView = picker
        firstResponder = textField
    }
    
    
    @IBAction func editingDidEnd(sender: AnyObject) {
        let textField = sender as! UITextField
        textField.inputView = nil
    }
    
    
    @IBAction func pickerChanged(sender: AnyObject) {
        let picker = sender as! UIDatePicker
        firstResponder.text = dateFormatter.stringFromDate(picker.date)
    }
    
}
