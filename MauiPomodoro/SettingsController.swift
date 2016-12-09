//
//  SettingsController.swift
//  ZoneHelper
//
//  Created by Алексей Карасев on 01/05/16.
//  Copyright © 2016 Justin Gordon. All rights reserved.
//

import UIKit

protocol SettingsControllerDelegate {
  func updateSettings()
}

class SettingsController: UITableViewController {
  
  @IBOutlet var timeInputs: [UITextField]!
  @IBOutlet weak var demoSwitch: UISwitch!
  fileprivate var dateFormatter: DateFormatter!
  fileprivate var firstResponder: UITextField!
  
  var delegate: SettingsControllerDelegate!
  
  @IBOutlet weak var about: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    let times = Settings.instance.times
    for (index, input) in timeInputs.enumerated() {
      //          disable input cursor
      (input.value(forKey: "textInputTraits") as AnyObject).setValue(UIColor.clear, forKey: "insertionPointColor")
      
      input.text = times[index]
    }
    demoSwitch.isOn = Settings.instance.demo
    
    let aboutText = NSMutableAttributedString(string: "Designed by the ShakaCode team.\nhttp://www.shakacode.com\n\nPlease contact us if you want additional features in this app.")
    let range = NSRange(location: 0, length: aboutText.length)
    let color = UIColor(red: 173.0/255, green: 173.0/255, blue: 173.0/255, alpha: 1.0)
    aboutText.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
    aboutText.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14), range: range)
    let mailRange = (aboutText.string as NSString).range(of: "contact us")
    let mailURL = URL(string: "mailto://contact@shakacode.com")!
    aboutText.addAttribute(NSLinkAttributeName, value: mailURL, range: mailRange)
    about.attributedText = aboutText
    about.textContainer.lineFragmentPadding = 0
    about.textContainerInset = UIEdgeInsets.zero
    
  }
  
  
  @IBAction func editingDidBegin(_ sender: UITextField) {
    
    let picker = UIDatePicker()
    picker.datePickerMode = .countDownTimer
    
    if let text = sender.text {
      let date = dateFormatter.date(from: text)!
      picker.setDate(date, animated: true)
    }
    picker.addTarget(self, action: #selector(SettingsController.pickerChanged(_:)), for: [.valueChanged])
    
    sender.inputView = picker
    firstResponder = sender
  }
  
  @IBAction func editingDidEnd(_ sender: UITextField) {
    sender.inputView = nil
    let times = timeInputs.map { $0.text! }
    Settings.instance.times = times
    delegate.updateSettings()
    
  }
  
  @IBAction func demoTapped(_ sender: UISwitch) {
    Settings.instance.demo = sender.isOn
    delegate.updateSettings()
  }
  @IBAction func tableTapped(_ sender: AnyObject) {
    tableView.endEditing(true)
  }
  
  @IBAction func pickerChanged(_ sender: AnyObject) {
    let picker = sender as! UIDatePicker
    firstResponder.text = dateFormatter.string(from: picker.date)
  }
    
  // Remove this override to show demo mode
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return section == 0 ? 0 : super.tableView(tableView, numberOfRowsInSection: section)
  }
}
